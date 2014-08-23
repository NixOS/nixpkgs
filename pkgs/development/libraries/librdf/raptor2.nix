{ stdenv, fetchurl, libxml2, libxslt, curl }:

stdenv.mkDerivation rec {
  name = "raptor2-2.0.12"; # 2.0.9 misses a header and so fails liblrdf

  src = fetchurl {
    url = "http://download.librdf.org/source/${name}.tar.gz";
    sha256 = "1644a1nnw5k6168v9gjfx1rcbij6ybjximd35a3zhcvyyijmb5di";
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
