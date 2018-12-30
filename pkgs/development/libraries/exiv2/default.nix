{ stdenv, fetchurl, fetchFromGitHub, zlib, expat, gettext
, cmake }:

stdenv.mkDerivation rec {
  name = "exiv2-${version}";
  version = "0.27";

  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = version;
    sha256 = "07gagwrankj9igjag95qhwn2cbj5g8n0m26xm9v7cwp0h16xr4a3";
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
