{ stdenv, fetchurl, libxml2, libxslt }:

stdenv.mkDerivation rec {
  pname = "raptor2";
  version = "2.0.15";

  src = fetchurl {
    url = "http://download.librdf.org/source/${pname}-${version}.tar.gz";
    sha256 = "ada7f0ba54787b33485d090d3d2680533520cd4426d2f7fb4782dd4a6a1480ed";
  };

  patches = [
    (fetchurl {
      name = "CVE-2017-18926.patch";
      url = "https://github.com/dajobe/raptor/commit/590681e546cd9aa18d57dc2ea1858cb734a3863f.patch";
      sha256 = "1qlpb5rm3j2yi0x6zgdi5apymg5zlvwq3g1zl417gkjrlvxmndgp";
    })
  ];

  buildInputs = [ libxml2 libxslt ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  meta = {
    description = "The RDF Parser Toolkit";
    homepage = "http://librdf.org/raptor";
    license = with stdenv.lib.licenses; [ lgpl21 asl20 ];
    maintainers = with stdenv.lib.maintainers; [ marcweber ];
    platforms = stdenv.lib.platforms.unix;
  };
}
