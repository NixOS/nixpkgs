{ lib, runCommand, glibc, glibc32
, variant # clang or gcc
}:

let
  nameVersion = builtins.parseDrvName glibc.name;
  glibc64 = glibc;
in
runCommand "${nameVersion.name}-multi-${nameVersion.version}"
  { outputs = [ "bin" "dev" "out"]; } # TODO: no static version here (yet)
  (''
    mkdir -p "$out/lib"

  '' + {
    "gcc" = ''
      ln -s '${glibc64.out}'/lib/* "$out/lib"
      ln -s '${glibc32.out}/lib' "$out/lib/32"
      ln -s lib "$out/lib64"
    '';
    "clang" = ''
      ln -s '${glibc64.out}/lib' "$out/lib/x86_64-unknown-linux-gnu"
      ln -s '${glibc32.out}/lib' "$out/lib/i686-unknown-linux-gnu"

      # expose linkers
      mkdir $out/lib/32
      ln -s ${glibc64.out}/lib/ld-linux* $out/lib
      ln -s ${glibc32.out}/lib/ld-linux* $out/lib/32
    '';
  }.${variant} + ''

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
  '')
