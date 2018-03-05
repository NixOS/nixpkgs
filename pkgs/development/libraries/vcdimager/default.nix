{ stdenv, lib, fetchurl, pkgconfig, libcdio, libxml2, popt }:

stdenv.mkDerivation rec {
  name = "vcdimager-2.0.1";

  src = fetchurl {
    url = "mirror://gnu/vcdimager/${name}.tar.gz";
    sha256 = "0ypnb1vp49nmzp5571ynlz6n1gh90f23w3z4x95hb7c2p7pmylb7";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libxml2 popt ];

  propagatedBuildInputs = [ libcdio ];

  meta = with lib; {
    homepage = http://www.gnu.org/software/vcdimager/;
    description = "Full-featured mastering suite for authoring, disassembling and analyzing Video CDs and Super Video CDs";
    platforms = platforms.gnu; # random choice
    license = licenses.gpl2;
  };
}
