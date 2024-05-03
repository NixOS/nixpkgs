import json
import textwrap
import functools
import re
from typing import Any, Callable
import subprocess
import tempfile
from pathlib import Path
import dataclasses
from concurrent.futures import ThreadPoolExecutor

REPO = 'https://github.com/frida/frida'
PREFETCH_THREADS = 4
# things to fetch versions of from deps.mk
DEPS_MK_NAMES = [
    'capstone', 'libiconv', 'zlib', 'pcre2', 'libffi', 'glib', 'selinux'
]


def get_versions() -> dict[str, str]:
    out = subprocess.check_output(['git', 'ls-remote', '--tags', REPO])

    def translate_line(line: str):
        [sha, refname] = line.split('\t')
        refname = refname.removeprefix('refs/tags/')
        return (refname, sha)

    return dict(translate_line(l) for l in out.decode('utf-8').splitlines())


def get_latest():
    versions = get_versions()
    versions_sorted = list(
        sorted(versions.keys(),
               key=lambda v: [int(comp) for comp in v.split('.')]))
    return versions_sorted[-1]


def get_module_versions(p: Path):
    output = subprocess.check_output(
        ['git', 'submodule', 'status', '--cached'], cwd=p).decode('utf-8')
    """
    format:
    -7bcf6fcdf26afe9dae338deea3b7204880b1ae28 frida-clr
    """

    def translate_line(line: str):
        [version, name] = line.removeprefix('-').split(' ')
        return (name, version)

    return dict(translate_line(l) for l in output.splitlines())


GITHUB_URL_RE = re.compile(
    r'https://github\.com/(?P<owner>[^/]+)/(?P<repo>[^/]+)')


@dataclasses.dataclass
class SubmoduleInfo:
    owner: str | None
    repo: str | None
    rev: str
    hash: str | None

    def prefetch(self):
        if self.hash: return
        assert self.owner and self.repo
        print('prefetching', self.owner, self.repo)
        self.hash = prefetch_github(self.owner, self.repo, self.rev)

    def apply_github_url(self, url: str):
        gh_match = GITHUB_URL_RE.match(url)
        if not gh_match:
            raise ValueError('bad github url', url)
        self.owner = gh_match.group('owner')
        self.repo = gh_match.group('repo').removesuffix('.git')


def extract_makefile_versions(p: Path):
    # This is incredibly dirty, but it will work!
    # Who needs a makefile parser anyway?
    subprocess.check_call(['git', 'sparse-checkout', 'add', 'releng'],
                          cwd=p / 'repo')
    makefile_name = p / 'repo/print_versions.mk'

    print_deps_content = '\n'.join(
        f"\techo {name} $({name}_url) $({name}_version)"
        for name in DEPS_MK_NAMES)
    makefile = textwrap.dedent("""
    include config.mk
    include releng/deps.mk
    print_deps:
    """) + print_deps_content

    with open(makefile_name, 'w') as fh:
        fh.write(makefile)

    output = subprocess.check_output(
        ['make', '--silent', '-f', makefile_name, 'print_deps'],
        cwd=p / 'repo')

    def process_line(line: str):
        [name, url, version] = line.split(' ')
        return (name, url, version)

    return [process_line(l) for l in output.decode('utf-8').splitlines()]


def inject_makefile_versions(frida_version: str, p: Path,
                             infos: dict[str, SubmoduleInfo]):
    versions = extract_makefile_versions(p)
    versions.append(('frida', REPO, frida_version))
    print('deps.mk has:')
    for (name, url, version) in versions:
        print(f'{name}: {url} {version}')
        infos[name] = SubmoduleInfo(rev=version,
                                    owner=None,
                                    repo=None,
                                    hash=None)
        infos[name].apply_github_url(url)


def git_submod_config_get(p: Path) -> list[tuple[str, str]]:
    output = subprocess.check_output(
        ['git', 'config', '--file', p, '--null', '--get-regexp', 'submodule'])
    settings_map = [
        tuple(s.decode('utf-8').split('\n', 1)) for s in output.split(b'\0')
        if s != b''
    ]
    return settings_map


def get_gitmodules(
    version: str,
    add_extra_submodules: Callable[[Path, dict[str, SubmoduleInfo]],
                                   None] = lambda *_: None):
    with tempfile.TemporaryDirectory() as d:
        dir_path = Path(d)
        subprocess.check_call([
            'git', 'clone', '--sparse', '--depth=1', '--filter=blob:none',
            '-b', version, REPO, dir_path / 'repo'
        ])

        infos: dict[str, SubmoduleInfo] = {}
        for (name, rev) in get_module_versions(dir_path / 'repo').items():
            infos[name] = SubmoduleInfo(
                owner=None,
                repo=None,
                rev=rev,
                hash=None,
            )
        add_extra_submodules(dir_path, infos)

        CONFIG_KEY_RE = re.compile(
            r'submodule\.(?P<submod_name>.*)\.(?P<meta_kind>.*)')

        for (cfg_name, cfg_value) in git_submod_config_get(dir_path /
                                                           'repo/.gitmodules'):
            match = CONFIG_KEY_RE.match(cfg_name)
            if not match:
                continue
            submod_name = match.group('submod_name')
            value_type = match.group('meta_kind')
            if value_type == 'url':
                infos[submod_name].apply_github_url(cfg_value)
        return infos


def prefetch_github(owner: str, repo: str, rev: str) -> str:
    out = json.loads(
        subprocess.check_output(
            ['nix-prefetch-github', '--json', '--rev', rev, owner, repo]))
    return out['hash']


def write_version_info(version: str, infos: dict[str, SubmoduleInfo]):
    tpe = ThreadPoolExecutor(PREFETCH_THREADS)
    for info in infos.values():
        tpe.submit(info.prefetch)
    tpe.shutdown(wait=True)

    infos2: dict[str, Any] = {
        k: dataclasses.asdict(v)
        for (k, v) in infos.items()
    }
    infos2['version'] = version
    with open('versions.json', 'w') as fh:
        json.dump(infos2, fh)
        fh.write('\n')


if __name__ == '__main__':
    version = get_latest()
    print('Latest version:', version)
    write_version_info(
        version,
        get_gitmodules(version,
                       functools.partial(inject_makefile_versions, version)))
