{ stdenv, fetchurl, fetchpatch, libjpeg, cmake }:

stdenv.mkDerivation rec {
  name = "jasper-2.0.6";

  src = fetchurl {
    # You can find this code on Github at https://github.com/mdadams/jasper
    # however note at https://www.ece.uvic.ca/~frodo/jasper/#download
    # not all tagged releases are for distribution.
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.tar.gz";
    sha256 = "0g6fl8rrbspa9vpswixmpxrg71l19kqgc2b5cak7vmwxphj01wbk";
  };

  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = "--enable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  meta = {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
