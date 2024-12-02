{lib, stdenv, fetchurl, buildPackages}:

stdenv.mkDerivation rec {
  pname = "yasm";
  version = "1.3.0";

  src = fetchurl {
    url = "https://www.tortall.net/projects/yasm/releases/yasm-${version}.tar.gz";
    sha256 = "0gv0slmm0qpq91za3v2v9glff3il594x5xsrbgab7xcmnh0ndkix";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  meta = with lib; {
    homepage = "http://www.tortall.net/projects/yasm/";
    description = "Complete rewrite of the NASM assembler";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
