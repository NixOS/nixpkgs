{ lib, stdenv, fetchurl, gettext, libgpgerror, libgcrypt, libksba, zlib }:

with lib;

stdenv.mkDerivation rec {
  pname = "ntbtls";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://gnupg/ntbtls/ntbtls-${version}.tar.bz2";
    sha256 = "sha256-ZJ/nSjEdE+Q7FrJuuqkWZd22MpJbc5AlkurD7TBRnhc=";
  };

  outputs = [ "dev" "out" ];

  buildInputs = [ libgcrypt libgpgerror libksba zlib ]
    ++ lib.optional stdenv.isDarwin gettext;

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
