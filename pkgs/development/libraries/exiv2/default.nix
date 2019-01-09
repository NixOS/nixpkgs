{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, zlib, expat, gettext
, autoconf }:

stdenv.mkDerivation rec {
  name = "exiv2-0.26.2018.12.30";

    #url = "http://www.exiv2.org/builds/${name}-trunk.tar.gz";
  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "f5d0b25"; # https://github.com/Exiv2/exiv2/commits/0.26
    sha256 = "1blaz3g8dlij881g14nv2nsgr984wy6ypbwgi2pixk978p0gm70i";
  };

  postPatch = "patchShebangs ./src/svn_version.sh";

  preConfigure = "make config"; # needed because not using tarball

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    gettext
    autoconf # needed because not using tarball
  ];
  propagatedBuildInputs = [ zlib expat ];

  meta = with stdenv.lib; {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
