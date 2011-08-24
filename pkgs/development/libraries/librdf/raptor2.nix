{ stdenv, fetchurl, libxml2, libxslt, curl }:

stdenv.mkDerivation rec {
  name = "raptor2-2.0.4";

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "0viaam60adhsxim2vaq5xs1pfmm6wiidxpkrhwyl7x9mz8x9vx1l";
  };

  buildInputs = [ libxml2 libxslt ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  meta = { 
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = "LGPL-2.1 Apache-2.0";
    maintainers = with stdenv.lib.maintainers; [ marcweber urkud ];
    platforms = stdenv.lib.platforms.linux;
  };
}
