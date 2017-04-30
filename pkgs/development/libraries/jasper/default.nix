{ stdenv, fetchurl, fetchpatch, libjpeg, cmake }:

stdenv.mkDerivation rec {
  name = "jasper-2.0.12";

  src = fetchurl {
    # You can find this code on Github at https://github.com/mdadams/jasper
    # however note at https://www.ece.uvic.ca/~frodo/jasper/#download
    # not all tagged releases are for distribution.
    url = "http://www.ece.uvic.ca/~mdadams/jasper/software/${name}.tar.gz";
    sha256 = "1njdbxv7d4anzrd476wjww2qsi96dd8vfnp4hri0srrqxpszl92v";
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

  meta = with stdenv.lib; {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = platforms.unix;
  };
}
