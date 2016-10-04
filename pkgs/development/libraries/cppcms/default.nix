{ stdenv, fetchurl, cmake, pcre, zlib, python, openssl }:

stdenv.mkDerivation rec {
  name = "cppcms";
  version = "1.0.5";

  src = fetchurl {
      url = "mirror://sourceforge/cppcms/${name}-${version}.tar.bz2";
      sha256 = "0r8qyp102sq4lw8xhrjhan0dnslhsmxj4zs9jzlw75yagfbqbdl4";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pcre zlib python openssl ];

  cmakeFlags = [
    "--no-warn-unused-cli"
  ];

  meta = with stdenv.lib; {
    homepage = "http://cppcms.com";
    description = "High Performance C++ Web Framework";
    platforms = platforms.linux ;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}

