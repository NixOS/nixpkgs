{lib, stdenv, fetchFromGitHub
, gsasl, gnutls, pkg-config, cmake, zlib, libtasn1, libgcrypt, gtk3
# this will not work on non-nixos systems
, sendmailPath ? "/run/wrappers/bin/sendmail"
}:

stdenv.mkDerivation rec {
  pname = "vmime";
  version = "0.9.2";
  src = fetchFromGitHub {
    owner = "kisli";
    repo = "vmime";
    rev = "v${version}";
    sha256 = "1304n50ny2av8bagjpgz55ag0nd7m313akm9bb73abjn6h5nzacv";
  };

  buildInputs = [ gsasl gnutls zlib libtasn1 libgcrypt gtk3 ];
  nativeBuildInputs = [ pkg-config cmake ];

  cmakeFlags = [
    "-DVMIME_SENDMAIL_PATH=${sendmailPath}"
  ];

  meta = {
    homepage = "https://www.vmime.org/";
    description = "Free mail library for C++";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
