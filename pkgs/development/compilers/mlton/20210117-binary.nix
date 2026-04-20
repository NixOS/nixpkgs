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
in
stdenv.mkDerivation rec {
  pname = "mlton";
  version = "20210117";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-linux-glibc2.31.tgz";
        hash = "sha256-dJy1nWuszWRBQ3Cb6GYQUijSttzUDFB6kLicm14PRdI=";
      })
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-darwin-19.6.gmp-static.tgz";
        hash = "sha256-W+qfYBNupoR4kMX05F1xJqMu8U/UaiMDyrh1ypXIzXY=";
      })
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      (fetchurl {
        url = "https://projects.laas.fr/tina/software/mlton-${version}-1.arm64-darwin-21.6-gmp-static.tgz";
        hash = "sha256-XYzEBG9QLKfZhnDVORXjoZc+wIJuTEwj4l1IP6ZXweg=";
      })
    else
      throw "Architecture not supported";

  patches = [
    (fetchpatch {
      name = "remove-duplicate-if.patch";
      url = "https://github.com/MLton/mlton/commit/22002cd0a53a1ab84491d74cb8dc6a4e50c1f7b7.patch";
      decode = "sed -e 's|Makefile\\.binary|Makefile|g'";
      hash = "sha256-Gtmc+OIh+m7ordSn74fpOKVDQDtYyLHe6Le2snNCBYQ=";
    })
  ];

  buildInputs = [
    bash
    gmp
  ];
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux patchelf;
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

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf --set-interpreter ${dynamic-linker} $out/lib/mlton/mlton-compile
      patchelf --set-rpath ${gmp}/lib $out/lib/mlton/mlton-compile

      for e in mllex mlnlffigen mlprof mlyacc; do
        patchelf --set-interpreter ${dynamic-linker} $out/bin/$e
        patchelf --set-rpath ${gmp}/lib $out/bin/$e
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
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
