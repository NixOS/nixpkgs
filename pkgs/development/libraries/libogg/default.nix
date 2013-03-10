{ stdenv, fetchurl, xz }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.0";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "0jy79ffkl34vycnwfsj4svqsdg1lwy2l1rr49y8r4d44kh12a5r3";
  };

  nativeBuildInputs = [ xz ];

  meta = {
    homepage = http://xiph.org/ogg/;
  };
}
