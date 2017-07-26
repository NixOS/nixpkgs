{ stdenv, fetchurl, libxml2, libxslt, curl }:

stdenv.mkDerivation rec {
  name = "raptor2-2.0.15";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed";
  };

  buildInputs = [ libxml2 libxslt ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  meta = {
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = with stdenv.lib.licenses; [ lgpl21 asl20 ];
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
