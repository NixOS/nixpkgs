{
  stdenv,
  lib,
  libidn2,
  libunistring,
  runCommandLocal,
  patchelf,
}:
# Construct a copy of libidn2.* where all (transitive) libc references (in .bin)
# get replaced by a new one, so that there's no reference to bootstrap tools.
runCommandLocal "${libidn2.pname}-${libidn2.version}"
  {
    outputs = [
      "bin"
      "dev"
      "out"
    ];
    passthru = {
      inherit (libidn2) out info devdoc; # no need to touch these store paths
    };
    inherit (libidn2) meta;
  }
  ''
    cp -r '${libidn2.bin}' "$bin"
    chmod +w "$bin"/bin/*
    patchelf \
      --set-interpreter '${stdenv.cc.bintools.dynamicLinker}' \
      --set-rpath '${
        lib.concatMapStringsSep ":" (p: lib.getLib p + "/lib") [
          stdenv.cc.libc
          libunistring
          libidn2
        ]
      }' \
      "$bin"/bin/*

    cp -r '${libidn2.dev}' "$dev"
    chmod +w "$dev"/nix-support/propagated-build-inputs
    substituteInPlace "$dev"/nix-support/propagated-build-inputs \
      --replace '${libidn2.bin}' "$bin"
    substituteInPlace "$dev"/lib/pkgconfig/libidn2.pc \
      --replace '${libidn2.dev}' "$dev"

    ln -s '${libidn2.out}' "$out" # it's hard to be without any $out
  ''
