{ stdenv, fetchurl, fetchpatch, unzip, libjpeg, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "jasper-1.900.28";

  src = fetchurl {
    # You can find this code on Github at https://github.com/mdadams/jasper
    # however note at https://www.ece.uvic.ca/~frodo/jasper/#download
    # not all tagged releases are for distribution.
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.tar.gz";
    sha256 = "0nsiblsfpfa0dahsk6hw9cd18fp9c8sk1z5hdp19m33c0bf92ip9";
  };

  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ unzip autoreconfHook ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = "--enable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
