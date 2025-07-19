{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  patchelf,
  bash,
  gmp,
}:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
  pname = "mlton";
  version = "20241230";
in
stdenv.mkDerivation {
  inherit pname version;
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-linux.ubuntu-24.04_static.tgz";
        sha256 = "sha256-dhcnfy0Mq6iA31cvarfxHfMRBDnCpNq53Rui4efNTOY=";
      })
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-darwin.macos-13_gmp-static.tgz";
        sha256 = "sha256-fW0hqjrWUcy+PIN8WHb1r4EYgfuwF9Zz3q7f2ZtxOi0=";
      })
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.arm64-darwin.macos-15_gmp-static.tgz";
        sha256 = "sha256-xhFP2plFjP/mbLz1CNtlZzkm0Kx6twfD/Dmn79Vj908=";
      })
    else
      throw "Architecture not supported";

  buildInputs = [
    bash
    gmp
  ];
  strictDeps = true;

  buildPhase = ''
    make update \
      CC="$(type -p cc)" \
      WITH_GMP_INC_DIR="${gmp.dev}/include" \
      WITH_GMP_LIB_DIR="${gmp}/lib"
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change \
      /opt/local/lib/libgmp.10.dylib \
      ${gmp}/lib/libgmp.10.dylib \
      $out/lib/mlton/mlton-compile

    for e in mllex mlnlffigen mlprof mlyacc; do
      install_name_tool -change \
        /opt/local/lib/libgmp.10.dylib \
        ${gmp}/lib/libgmp.10.dylib \
        $out/bin/$e
    done
  '';

  meta = import ./meta.nix { inherit lib; };
}
