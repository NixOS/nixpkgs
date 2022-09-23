{ lib, stdenv, fetchurl, fetchpatch, xmlto, docbook_xml_dtd_412, docbook_xsl, libxml2, fixDarwinDylibNames, pkgsStatic }:

stdenv.mkDerivation rec {
  pname = "giflib";
  version = "5.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/giflib/giflib-${version}.tar.gz";
    sha256 = "1gbrg03z1b6rlrvjyc6d41bc8j1bsr7rm8206gb1apscyii5bnii";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin
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
  ''
  # Upstream build system does not support NOT building shared libraries.
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    sed -i '/all:/ s/libgif.so//' Makefile
    sed -i '/all:/ s/libutil.so//' Makefile
    sed -i '/-m 755 libgif.so/ d' Makefile
    sed -i '/ln -sf libgif.so/ d' Makefile
  '';

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ fixDarwinDylibNames ];

  passthru.tests.static = pkgsStatic.giflib;

  meta = {
    description = "A library for reading and writing gif images";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    branch = "5.2";
  };
}
