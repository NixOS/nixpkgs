{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, asciidoc
, libxslt
, docbook_xsl
, pam
, yubikey-personalization
, libyubikey
, libykclient
}:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "2.27";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = version;
    sha256 = "0hb773zlf11xz4bwmsqv2mq5d4aq2g0crdr5cp9xwc4ivi5gd4kg";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config asciidoc libxslt docbook_xsl ];
  buildInputs = [ pam yubikey-personalization libyubikey libykclient ];

  meta = with lib; {
    description = "Yubico PAM module";
    homepage = "https://developers.yubico.com/yubico-pam";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
