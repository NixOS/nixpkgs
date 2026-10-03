{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  asciidoc,
  libxslt,
  docbook_xsl,
  pam,
  yubikey-personalization,
  libyubikey,
  libykclient,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yubico-pam";
  version = "2.27";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubico-pam";
    rev = finalAttrs.version;
    hash = "sha256-b5L2StyRMN7TZSW3zMATWJFWcBUb68oX+T0ER/84Z0E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
    libxslt
    docbook_xsl
  ];
  buildInputs = [
    pam
    yubikey-personalization
    libyubikey
    libykclient
  ];

  meta = {
    description = "Yubico PAM module";
    mainProgram = "ykpamcfg";
    homepage = "https://developers.yubico.com/yubico-pam";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
