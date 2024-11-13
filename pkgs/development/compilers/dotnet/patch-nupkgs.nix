{
  stdenv,
  lib,
  zlib,
  curl,
  icu,
  libunwind,
  libuuid,
  openssl,
  lttng-ust_2_12,
  patchelf,
  writeShellScriptBin,
}:

let
  binaryRPath = lib.makeLibraryPath (
    [
      stdenv.cc.cc
      zlib
      curl
      icu
      libunwind
      libuuid
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux lttng-ust_2_12
  );

in
writeShellScriptBin "patch-nupkgs" (
  ''
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
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for x in */* */*; do
      # .nupkg.metadata is written last, so we know the packages is complete
      [[ -d "$x" ]] && [[ -f "$x"/.nupkg.metadata ]] \
        && [[ ! -f "$x"/.nix-patched ]] || continue
      echo "Patching package $x"
      find "$x" -type f -print0 | while IFS= read -rd "" p; do
        if [[ "$p" != *.nix-patched ]] \
          && isELF "$p" \
          && ${patchelf}/bin/patchelf --print-interpreter "$p" &>/dev/null; then
          tmp="$p".$$.nix-patched
          # if this fails to copy then another process must have patched it
          cp --reflink=auto "$p" "$tmp" || continue
          echo "Patchelfing $p as $tmp"
          ${patchelf}/bin/patchelf \
            --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
            "$tmp" ||:
          # This makes sure that if the binary requires some specific runtime dependencies, it can find it.
          # This fixes dotnet-built binaries like crossgen2
          ${patchelf}/bin/patchelf \
            --add-needed libicui18n.so \
            --add-needed libicuuc.so \
            --add-needed libz.so \
            --add-needed libssl.so \
            "$tmp"
          ${patchelf}/bin/patchelf \
            --add-rpath "${binaryRPath}" \
            "$tmp" ||:
          mv "$tmp" "$p"
        fi
      done
      touch "$x"/.nix-patched
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    for x in microsoft.dotnet.ilcompiler/*; do
      # .nupkg.metadata is written last, so we know the packages is complete
      [[ -d "$x" ]] && [[ -f "$x"/.nupkg.metadata ]] \
        && [[ ! -f "$x"/.nix-patched-ilcompiler ]] || continue
      echo "Patching package $x"
      pushd "$x"
      sed -i 's: -no_code_signature_warning::g' build/Microsoft.NETCore.Native.targets
      sed -i 's:Include="-ld_classic"::g' build/Microsoft.NETCore.Native.Unix.targets
      touch .nix-patched-ilcompiler
      popd
    done
  ''
)
