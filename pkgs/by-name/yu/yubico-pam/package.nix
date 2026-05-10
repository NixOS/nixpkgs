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
    sha256 = "0hb773zlf11xz4bwmsqv2mq5d4aq2g0crdr5cp9xwc4ivi5gd4kg";
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
