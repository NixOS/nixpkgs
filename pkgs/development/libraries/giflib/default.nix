{ stdenv, fetchurl, fetchpatch, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  name = "giflib-5.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/giflib/${name}.tar.gz";
    sha256 = "1gbrg03z1b6rlrvjyc6d41bc8j1bsr7rm8206gb1apscyii5bnii";
  };

  patches = stdenv.lib.optional stdenv.hostPlatform.isDarwin
    (fetchpatch {
      # https://sourceforge.net/p/giflib/bugs/133/
      name = "darwin-soname.patch";
      url = "https://sourceforge.net/p/giflib/bugs/_discuss/thread/4e811ad29b/c323/attachment/Makefile.patch";
      sha256 = "12afkqnlkl3n1hywwgx8sqnhp3bz0c5qrwcv8j9hifw1lmfhv67r";
      extraPrefix = "./";
    });

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'PREFIX = /usr/local' 'PREFIX = ${builtins.placeholder "out"}'
  '';

  nativeBuildInputs = stdenv.lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [ xmlto docbook_xml_dtd_412 docbook_xsl libxml2 ];

  meta = {
    description = "A library for reading and writing gif images";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    branch = "5.2";
  };
}
