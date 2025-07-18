{
  lib,
  runCommand,
  glibc,
  glibc32,
}:

let
  nameVersion = builtins.parseDrvName glibc.name;
  glibc64 = glibc;
in
runCommand "${nameVersion.name}-multi-${nameVersion.version}"
  # out as the first output is an exception exclusive to glibc
  {
    outputs = [
      "out"
      "bin"
      "dev"
      "static"
    ];
    passthru = {
      libgcc = lib.lists.filter (x: x != null) [
        (glibc64.libgcc or null)
        (glibc32.libgcc or null)
      ];
    };
  }
  ''
    mkdir -p "$out/lib"
    ln -s '${glibc64.out}'/lib/* "$out/lib"
    ln -s '${glibc32.out}/lib' "$out/lib/32"
    ln -s lib "$out/lib64"

    # fixing ldd RLTDLIST
    mkdir -p "$bin/bin"
    cp -s '${glibc64.bin}'/bin/* "$bin/bin/"
    rm "$bin/bin/ldd"
    sed -e "s|^RTLDLIST=.*$|RTLDLIST=\"$out/lib/ld-linux-x86-64.so.2 $out/lib/32/ld-linux.so.2\"|g" \
        '${glibc64.bin}/bin/ldd' > "$bin/bin/ldd"
    chmod +x "$bin/bin/ldd"

    mkdir "$dev"
    cp -rs '${glibc32.dev}'/include "$dev/"
    chmod +w -R "$dev"
    cp -rsf '${glibc64.dev}'/include "$dev/"

    mkdir -p "$static/lib" "$static/lib64"
    # create symlinks for files used for dynamic linking
    # -> removing this will cause dynamically linked programs to segfault
    cp -rs '${glibc32.out}'/lib/* "$static/lib"
    cp -rs '${glibc64.out}'/lib/* "$static/lib64"
    # create symlinks for files used for static linking
    cp -rs '${glibc32.static}'/lib/* "$static/lib"
    cp -rs '${glibc64.static}'/lib/* "$static/lib64"
  ''
