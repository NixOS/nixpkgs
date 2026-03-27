{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  gmp,
}:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
in
stdenv.mkDerivation rec {
  pname = "mlton";
  version = "20180207";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-linux.tgz";
        hash = "sha256-jkq9ufPvgcAbmJpmc03KKn9BicVWc6HIu61U58spmDg=";
      })
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      (fetchurl {
        url = "https://github.com/MLton/mlton/releases/download/on-${version}-release/${pname}-${version}-1.amd64-darwin.gmp-static.tgz";
        hash = "sha256-uy2YLvl9bvTv4HjSOgm68+Uvb9bI8aYAFuFiRDj0h7M=";
      })
    else
      throw "Architecture not supported";

  buildInputs = [ gmp ];
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isLinux patchelf;

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
