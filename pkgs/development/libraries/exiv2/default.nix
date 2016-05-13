{ stdenv, fetchurl, fetchpatch, zlib, expat, gettext }:

stdenv.mkDerivation rec {
  name = "exiv2-0.25";

  src = fetchurl {
    url = "http://www.exiv2.org/${name}.tar.gz";
    sha256 = "197g6vgcpyf9p2cwn5p5hb1r714xsk1v4p96f5pv1z8mi9vzq2y8";
  };
  postPatch = "patchShebangs ./src/svn_version.sh";

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ gettext ];
  propagatedBuildInputs = [ zlib expat ];

  meta = {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = stdenv.lib.platforms.all;
  };
}
