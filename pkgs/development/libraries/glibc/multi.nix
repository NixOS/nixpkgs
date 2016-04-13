{ runCommand, glibc, glibc32
}:

let
  nameVersion = builtins.parseDrvName glibc.name;
  glibc64 = glibc;
in
runCommand "${nameVersion.name}-multi-${nameVersion.version}"
  { outputs = [ "dev" "out" "bin" ]; } # TODO: no static version here (yet)
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
    cp -rs '${glibc32}'/include "$dev/"
    chmod +w -R "$dev"
    cp -rsf '${glibc64}'/include "$dev/"
  ''
