{stdenv, fetchurl, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2 }:

stdenv.mkDerivation rec {
  name = "giflib-5.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/giflib/${name}.tar.gz";
    sha256 = "1gbrg03z1b6rlrvjyc6d41bc8j1bsr7rm8206gb1apscyii5bnii";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'PREFIX = /usr/local' 'PREFIX = ${builtins.placeholder "out"}'
  '';

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];

  meta = {
    description = "A library for reading and writing gif images";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    branch = "5.2";
  };
}
