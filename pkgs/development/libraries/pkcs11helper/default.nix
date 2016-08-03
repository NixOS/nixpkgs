{ stdenv, fetchurl, pkgconfig, openssl, autoreconfHook }:

let
  rev = "5d412bad60";
in
stdenv.mkDerivation rec {
  name = "pkcs11-helper-20121123-${rev}";

  src = fetchurl {
    url = "https://github.com/alonbl/pkcs11-helper/tarball/${rev}";
    name = "${name}.tar.gz";
    sha256 = "1mih6mha39yr5s5m18lg4854qc105asgnwmjw7f95kgmzni62kxp";
  };

  buildInputs = [ pkgconfig openssl autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://www.opensc-project.org/opensc/wiki/pkcs11-helper;
    license = with licenses; [ "BSD" gpl2 ];
    description = "Library that simplifies the interaction with PKCS#11 providers";
    platforms = platforms.unix;
  };
}
