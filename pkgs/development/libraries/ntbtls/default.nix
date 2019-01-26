{ stdenv, fetchurl, gettext, libgpgerror, libgcrypt, libksba, zlib }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ntbtls-${version}";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://gnupg/ntbtls/ntbtls-${version}.tar.bz2";
    sha256 = "1rywgdyj7prmwdi5r1rpglakqpnjskgln1mqksqm28qcwn2dnh42";
  };

  outputs = [ "dev" "out" ];

  buildInputs = [ libgcrypt libgpgerror libksba zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin gettext;

  postInstall = ''
    moveToOutput "bin/ntbtls-config" $dev
  '';

  meta = {
    description = "A tiny TLS 1.2 only implementation";
    homepage = "https://www.gnupg.org/software/ntbtls/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
