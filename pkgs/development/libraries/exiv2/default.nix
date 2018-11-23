{ stdenv, fetchurl, fetchFromGitHub, zlib, expat, gettext
, cmake }:

stdenv.mkDerivation rec {
  name = "exiv2-0.27-rc2";

  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "0.27-RC2";
    sha256 = "04zcfspdg5ypyky3g8p1mxbfy8i083iqbaihnjk6cqnhf6w6pq6r";
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
