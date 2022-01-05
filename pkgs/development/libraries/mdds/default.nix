{ lib, stdenv, fetchurl, boost, llvmPackages }:

stdenv.mkDerivation rec {
  pname = "mdds";
  version = "2.0.1";

  src = fetchurl {
    url = "https://kohei.us/files/${pname}/src/${pname}-${version}.tar.bz2";
    sha256 = "sha256-OrM/zljmrPlUDMGlImS+aGPvgPVawocZTMmM2kjnH+Y=";
  };

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cp "$out/share/pkgconfig/"* "$out/lib/pkgconfig"
  '';

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  checkInputs = [ boost ];

  meta = with lib; {
    homepage = "https://gitlab.com/mdds/mdds";
    description = "A collection of multi-dimensional data structure and indexing algorithm";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
