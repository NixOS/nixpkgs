{ lib, stdenv, fetchurl, bison }:

stdenv.mkDerivation rec {
  pname = "buddy";
  version = "2.4";

  src = fetchurl {
    url = "mirror://sourceforge/buddy/${pname}-${version}.tar.gz";
    sha256 = "0dl86l9xkl33wnkz684xa9axhcxx2zzi4q5lii0axnb9lsk81pyk";
  };

  buildInputs = [ bison ];
  patches = [ ./gcc-4.3.3-fixes.patch ];
  configureFlags = [ "CFLAGS=-O3" "CXXFLAGS=-O3" ];
  NIX_LDFLAGS = "-lm";
  doCheck = true;

  meta = {
    homepage = "https://sourceforge.net/projects/buddy/";
    description = "Binary decision diagram package";
    license = "as-is";

    platforms = lib.platforms.unix; # Once had cygwin problems
  };
}
