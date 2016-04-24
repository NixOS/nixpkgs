{ stdenv, fetchurl, cmake, ogre, freetype, boost, expat }:

stdenv.mkDerivation rec {
  name = "cegui-${version}";
  version = "0.8.4";

  src = fetchurl {
    url = "mirror://sourceforge/crayzedsgui/${name}.tar.bz2";
    sha256 = "1253aywv610rbs96hwqiw2z7xrrv24l3jhfsqj95w143idabvz5m";
  };


  buildInputs = [ cmake ogre freetype boost expat ];

  meta = with stdenv.lib; {
    homepage = http://cegui.org.uk/;
    description = "C++ Library for creating GUIs";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
