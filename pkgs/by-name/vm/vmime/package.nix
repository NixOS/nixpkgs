{
  lib,
  stdenv,
  fetchFromGitHub,
  gsasl,
  gnutls,
  pkg-config,
  cmake,
  zlib,
  libtasn1,
  libgcrypt,
  gtk3,
  # this will not work on non-nixos systems
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

stdenv.mkDerivation {
  pname = "vmime";
  # XXX: using unstable rev for now to comply with the removal of
  # deprecated symbols in the latest release of gsasl
  version = "0-unstable-2025-07-21";
  src = fetchFromGitHub {
    owner = "kisli";
    repo = "vmime";
    rev = "7046a4360bbeea21d1d8b5cfa4589bb4df7f980d";
    sha256 = "sha256-cwilSnybH5E0wq384lPnqAjPkQTLtlWS8NhmoFE/13k=";
  };

  buildInputs = [
    gsasl
    gnutls
    zlib
    libtasn1
    libgcrypt
    gtk3
  ];
  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  cmakeFlags = [
    "-DVMIME_SENDMAIL_PATH=${sendmailPath}"
  ];

  meta = {
    homepage = "https://www.vmime.org/";
    description = "Free mail library for C++";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
