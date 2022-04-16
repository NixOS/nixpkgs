{ lib, stdenv, fetchgit, gmp }:

stdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.6";

  src = fetchgit {
    url = "git://www.ginac.de/cln.git";
    rev = "cln_${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-P32F4TIDhE2Dwzydq8iFK6ch3kICJcXeeXHs5PBQG88=";
  };

  buildInputs = [ gmp ];

  meta = with lib; {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = "https://www.ginac.de/CLN/";
    license = licenses.gpl2;
    platforms = platforms.unix; # Once had cygwin problems
  };
}
