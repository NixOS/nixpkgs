#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i python3 -p "python3.withPackages (p: [ p.pycdlib p.mfusepy ])" p7zip
"""Regenerate ranges.nix and the hash in package.nix for a Windows 11 ISO.

usage: update.py [ISO-URL]   (default: the URL already in package.nix)

Mounts install.wim from the remote ISO with FUSE, fetching only what is read,
runs the same 7z extraction as the package and records the byte ranges 7z
reads. Needs a working fusermount3 (on NixOS: /run/wrappers/bin).
"""
import errno, http.client, json, os, re, stat, subprocess, sys, tempfile, time
import urllib.parse

import mfusepy as fuse
import pycdlib

HERE = os.path.dirname(os.path.abspath(__file__))
PACKAGE = os.path.join(HERE, "package.nix")
BLK = 1 << 20  # fetch granularity
GAP = 1 << 16  # merge recorded ranges closer than this
PATTERNS = [
    "Windows/Fonts/*.ttf",
    "Windows/Fonts/*.ttc",
    "Windows/System32/Licenses/neutral/*/*/license.rtf",
]


class Remote:
    """Random access to a URL via HTTP range requests, cached in a sparse file."""

    def __init__(self, url, cache_path):
        self.u = urllib.parse.urlsplit(url)
        self.conn = None
        self.have = set()
        self.reads = []
        self.size = int(self._req("HEAD", {})[0].getheader("Content-Length"))
        with open(cache_path, "wb") as f:
            f.truncate(self.size)
        self.cache = open(cache_path, "r+b")

    def _req(self, method, headers):
        for attempt in range(5):
            try:
                if self.conn is None:
                    self.conn = http.client.HTTPSConnection(self.u.netloc, timeout=60)
                path = self.u.path + (f"?{self.u.query}" if self.u.query else "")
                self.conn.request(method, path, headers=headers)
                r = self.conn.getresponse()
                return r, r.read()
            except (OSError, http.client.HTTPException):
                self.conn = None
                time.sleep(1 + attempt)
        sys.exit(f"HTTP {method} failed: {self.u.geturl()}")

    def pread(self, off, n):
        n = max(0, min(n, self.size - off))
        if n == 0:
            return b""
        self.reads.append((off, n))
        first, last = off // BLK, (off + n - 1) // BLK
        for b in range(first, last + 1):
            if b in self.have:
                continue
            start, end = b * BLK, min((b + 1) * BLK, self.size) - 1
            r, data = self._req("GET", {"Range": f"bytes={start}-{end}"})
            if r.status != 206 or len(data) != end - start + 1:
                sys.exit(f"range request failed: HTTP {r.status}")
            self.cache.seek(start)
            self.cache.write(data)
            self.have.add(b)
        self.cache.seek(off)
        return self.cache.read(n)


class FileObj:
    """Seekable file object over Remote, for pycdlib."""

    def __init__(self, r):
        self.r, self.pos = r, 0

    def seek(self, off, whence=0):
        self.pos = [off, self.pos + off, self.r.size + off][whence]
        return self.pos

    def tell(self):
        return self.pos

    def read(self, n=-1):
        d = self.r.pread(self.pos, self.r.size - self.pos if n < 0 else n)
        self.pos += len(d)
        return d


class WimFS(fuse.Operations):
    use_ns = True

    def __init__(self, r, off, size):
        self.r, self.off, self.size = r, off, size

    def getattr(self, path, fh=None):
        if path == "/":
            return dict(st_mode=stat.S_IFDIR | 0o755, st_nlink=2)
        if path == "/install.wim":
            return dict(st_mode=stat.S_IFREG | 0o444, st_nlink=1, st_size=self.size)
        raise fuse.FuseOSError(errno.ENOENT)

    def readdir(self, path, fh):
        return [".", "..", "install.wim"]

    def read(self, path, size, offset, fh):
        return self.r.pread(self.off + offset, max(0, min(size, self.size - offset)))


def trace(url, tmp):
    """Return (wim offset, wim size, ranges relative to the WIM, extracted dir)."""
    r = Remote(url, os.path.join(tmp, "iso.sparse"))
    iso = pycdlib.PyCdlib()
    iso.open_fp(FileObj(r))
    with iso.open_file_from_iso(udf_path="/sources/install.wim") as f:
        # Windows ISOs store install.wim contiguously; the magic check catches it if not.
        wim_off, wim_size = f._startpos, f._length
    if r.pread(wim_off, 8) != b"MSWIM\0\0\0":
        sys.exit("install.wim is not where pycdlib says it is")

    mnt, out, log = (os.path.join(tmp, d) for d in ("mnt", "out", "reads.json"))
    os.mkdir(mnt)
    os.mkdir(out)
    r.reads.clear()
    pid = os.fork()
    if pid == 0:  # child: serve the WIM until unmounted, then hand over the reads
        try:
            fuse.FUSE(WimFS(r, wim_off, wim_size), mnt, foreground=True, ro=True, nothreads=True)
        finally:
            with open(log, "w") as f:
                json.dump(r.reads, f)
            os._exit(0)
    try:
        for _ in range(100):
            if os.path.exists(os.path.join(mnt, "install.wim")):
                break
            time.sleep(0.1)
        else:
            sys.exit("FUSE mount did not come up")
        subprocess.run(
            ["7z", "x", "-y", os.path.join(mnt, "install.wim"), "-r-", *PATTERNS],
            cwd=out, check=True, stdout=subprocess.DEVNULL,
        )
    finally:
        subprocess.run(["fusermount3", "-u", mnt], check=False)
        os.waitpid(pid, 0)

    ranges = []
    for off, n in sorted(json.load(open(log))):
        off -= wim_off
        if ranges and off - ranges[-1][1] <= GAP:
            ranges[-1][1] = max(ranges[-1][1], off + n)
        else:
            ranges.append([off, off + n])
    return wim_off, wim_size, ranges, out


def main():
    src = open(PACKAGE).read()
    url = sys.argv[1] if len(sys.argv) > 1 else re.search(r'url = "([^"]+)";', src)[1]
    build = re.search(r"/(\d+\.\d+)\.\d+-\d+\.[^/]*\.iso$", url)
    if not build:
        sys.exit(f"cannot read the build number from {url}")
    version = f"10.0.{build[1]}"

    with tempfile.TemporaryDirectory() as tmp:
        wim_off, wim_size, ranges, out = trace(url, tmp)
        fonts = os.listdir(os.path.join(out, "Windows", "Fonts"))
        if len(fonts) < 100:
            sys.exit(f"only {len(fonts)} fonts extracted, refusing to update")
        out_hash = subprocess.run(
            ["nix", "--extra-experimental-features", "nix-command", "hash", "path", out],
            check=True, capture_output=True, text=True,
        ).stdout.strip()

    with open(os.path.join(HERE, "ranges.nix"), "w") as f:
        f.write("# Generated by update.py: the parts of install.wim that hold the fonts.\n{\n")
        f.write(f"  wimOffset = {wim_off};\n  wimSize = {wim_size};\n  ranges = [\n")
        # nixfmt style, so an update leaves no formatting diff
        f.writelines(f"    [\n      {a}\n      {b - 1}\n    ]\n" for a, b in ranges)
        f.write("  ];\n}\n")

    src = re.sub(r'version = "[^"]+";', f'version = "{version}";', src, count=1)
    src = re.sub(r'url = "[^"]+";', f'url = "{url}";', src, count=1)
    src = re.sub(r'"sha256-[A-Za-z0-9+/]+=*"', f'"{out_hash}"', src, count=1)
    with open(PACKAGE, "w") as f:
        f.write(src)

    size = sum(b - a for a, b in ranges)
    print(f"{version}: {len(fonts)} fonts, {len(ranges)} ranges, {size / 2**20:.0f} MiB")


if __name__ == "__main__":
    main()
