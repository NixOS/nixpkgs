{ stdenv
, lib
, dotnetCorePackages
, zlib
, curl
, icu
, libunwind
, libuuid
, openssl
, lttng-ust_2_12
, writeShellScriptBin
}:

let
  buildRid = dotnetCorePackages.systemToDotnetRid stdenv.buildPlatform.system;

  binaryRPath = lib.makeLibraryPath ([
    stdenv.cc.cc
    zlib
    curl
    icu
    libunwind
    libuuid
    openssl
  ] ++ lib.optional stdenv.isLinux lttng-ust_2_12);

in writeShellScriptBin "patch-nupkgs" ''
  set -euo pipefail
  shopt -s nullglob
  isELF() {
      local fn="$1"
      local fd
      local magic
      exec {fd}< "$fn"
      read -r -n 4 -u "$fd" magic
      exec {fd}<&-
      if [ "$magic" = $'\177ELF' ]; then return 0; else return 1; fi
  }
  cd "$1"
  for x in *.${buildRid}/* *.${buildRid}.*/*; do
    [[ -d "$x" ]] && [[ ! -f "$x"/.nix-patched ]] || continue
    echo "Patching package $x"
    pushd "$x"
    for p in $(find -type f); do
      if [[ "$p" != *.nix-patched ]] && isELF "$p"; then
        tmp="$p".$$.nix-patched
        # if this fails to copy then another process must have patched it
        cp --reflink=auto "$p" "$tmp" || continue
        echo "Patchelfing $p as $tmp"
        patchelf \
          --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
          "$tmp" ||:
        patchelf \
          --set-rpath "${binaryRPath}" \
          "$tmp" ||:
        mv "$tmp" "$p"
      fi
    done
    touch .nix-patched
    popd
  done
''
