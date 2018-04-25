{ stdenv, fetchurl, gettext, libgpgerror, libgcrypt, libksba, zlib }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ntbtls-${version}";
  version = "0.1.1";

  src = fetchurl {
    url = "mirror://gnupg/ntbtls/ntbtls-${version}.tar.bz2";
    sha256 = "0d322kgih43vr0gvy7kdj4baql1d6fa71vgpv0z63ira9pk4q9rd";
  };

  outputs = [ "dev" "out" ];

  buildInputs = [ libgcrypt libgpgerror libksba zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin gettext;

  postInstall = ''
    moveToOutput "bin/ntbtls-config" $dev
  '';

  meta = {
    description = "A tiny TLS 1.2 only implementation";
    homepage = https://www.gnupg.org/software/ntbtls/index.html;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joachifm ];
  };
}
