{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  bash,
  gmp,
}:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
  pname = "mlton";
  version = "20241230";
  link =
    { arch, os }:
    "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.${arch}-${os}.tgz";
in
stdenv.mkDerivation {
  inherit pname version;
  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = link {
          arch = "amd64";
          os = "linux.ubuntu-24.04_glibc2.39";
        };
        hash = "sha256-ldXnjHcWGu77LP9WL6vTC6FngzhxPFAUflAA+bpIFZM=";
      })
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      (fetchurl {
        url = link {
          arch = "arm64";
          os = "linux.ubuntu-24.04-arm_glibc2.39";
        };
        hash = "sha256-rn65t253SfUShAM3kXiLQJHT7JS7EO3fAPB23LWIwfc=";
      })
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      (fetchurl {
        url = link {
          arch = "amd64";
          os = "darwin.macos-13_gmp-static";
        };
        sha256 = "sha256-fW0hqjrWUcy+PIN8WHb1r4EYgfuwF9Zz3q7f2ZtxOi0=";
      })
    else if stdenv.hostPlatform.system == "aarch64-darwin" then
      (fetchurl {
        url = link {
          arch = "arm64";
          os = "darwin.macos-15_gmp-static";
        };
        hash = "sha256-xhFP2plFjP/mbLz1CNtlZzkm0Kx6twfD/Dmn79Vj908=";
      })
    else
      throw "Architecture not supported";

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

  meta = import ./meta.nix;
}
