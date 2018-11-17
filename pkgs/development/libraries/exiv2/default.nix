{ stdenv, fetchurl, fetchFromGitHub, zlib, expat, gettext
, cmake }:

stdenv.mkDerivation rec {
  name = "exiv2-0.27-rc1";

  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "a099f24";
    sha256 = "1nk5zy7rrf9sv4275gh3pd7k9bxh2h04fg4582d99s4s77gbr4c5";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ gettext cmake ];
  propagatedBuildInputs = [ zlib expat ];

  meta = with stdenv.lib; {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
