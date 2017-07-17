{ stdenv, fetchurl, fetchpatch, zlib, expat, gettext }:

stdenv.mkDerivation rec {
  name = "exiv2-0.26";

  src = fetchurl {
    url = "http://www.exiv2.org/builds/${name}-trunk.tar.gz";
    sha256 = "1yza317qxd8yshvqnay164imm0ks7cvij8y8j86p1gqi1153qpn7";
  };
  postPatch = "patchShebangs ./src/svn_version.sh";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ gettext ];
  propagatedBuildInputs = [ zlib expat ];

  meta = {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = stdenv.lib.platforms.all;
  };
}
