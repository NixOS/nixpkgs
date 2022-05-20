{ lib, stdenv, fetchurl, fetchgit, gmp }:

stdenv.mkDerivation rec {
  pname = "cln";
  version = "1.3.6";

  src = if stdenv.isDarwin then fetchgit {
    url = "git://www.ginac.de/cln.git";
    rev = "cln_${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "sha256-P32F4TIDhE2Dwzydq8iFK6ch3kICJcXeeXHs5PBQG88=";
  } else fetchurl {
    url = "${meta.homepage}${pname}-${version}.tar.bz2";
    sha256 = "0jlq9l4hphk7qqlgqj9ihjp4m3rwjbhk6q4v00lsbgbri07574pl";
  };

  buildInputs = [ gmp ];

  meta = with lib; {
    description = "C/C++ library for numbers, a part of GiNaC";
    homepage = "https://www.ginac.de/CLN/";
    license = licenses.gpl2;
    platforms = platforms.unix; # Once had cygwin problems
  };
}
