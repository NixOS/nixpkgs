{ stdenv, fetchurl, cmake, ogre, freetype, boost, expat }:

stdenv.mkDerivation rec {
  name = "cegui-${version}";
  version = "0.8.7";

  src = fetchurl {
    url = "mirror://sourceforge/crayzedsgui/${name}.tar.bz2";
    sha256 = "067562s71kfsnbp2zb2bmq8zj3jk96g5a4rcc5qc3n8nfyayhldk";
  };


  buildInputs = [ cmake ogre freetype boost expat ];

  meta = with stdenv.lib; {
    homepage = http://cegui.org.uk/;
    description = "C++ Library for creating GUIs";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
