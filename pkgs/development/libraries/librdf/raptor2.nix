{ stdenv, fetchurl, libxml2, libxslt, curl }:

stdenv.mkDerivation rec {
  name = "raptor2-2.0.8"; # 2.0.9 misses a header and so fails liblrdf

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "1mz7cxnfw73saf74c9if06n2mlsvn2rnn67vy7j2mq3wkhy0hcb0";
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
