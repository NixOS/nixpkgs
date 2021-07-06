{ lib, stdenv, fetchurl, cmake, pcre, zlib, python2, openssl }:

stdenv.mkDerivation rec {
  pname = "cppcms";
  version = "1.2.1";

  src = fetchurl {
      url = "mirror://sourceforge/cppcms/${pname}-${version}.tar.bz2";
      sha256 = "0lmcdjzicmzhnr8pa0q3f5lgapz2cnh9w0dr56i4kj890iqwgzhh";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ pcre zlib python2 openssl ];

  strictDeps = true;

  cmakeFlags = [
    "--no-warn-unused-cli"
  ];

  meta = with lib; {
    homepage = "http://cppcms.com";
    description = "High Performance C++ Web Framework";
    platforms = platforms.linux ;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}

