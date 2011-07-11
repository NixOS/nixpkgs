{ stdenv, fetchurl, libxml2, libxslt, curl }:

stdenv.mkDerivation rec {
  name = "raptor2-2.0.3";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "1icfg01zx3d3czqz774ar2mmnp8a9m248y5zvi5yn0fzs0nyc8g2";
  };

  buildInputs = [ libxml2 libxslt ];

  postInstall = "rm -rf $out/share/gtk-doc";

  meta = { 
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
