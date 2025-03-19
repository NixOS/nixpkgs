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
  version = "unstable-2022-03-26";
  src = fetchFromGitHub {
    owner = "kisli";
    repo = "vmime";
    rev = "fc69321d5304c73be685c890f3b30528aadcfeaf";
    sha256 = "sha256-DUcGQcT7hp5Rs2Z5C8wo+3BYwWqED0KrF3h3vgLiiow=";
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
