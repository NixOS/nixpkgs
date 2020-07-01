{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, asciidoc, libxslt, docbook_xsl
, pam, yubikey-personalization, libyubikey, libykclient }:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "unstable-2019-07-01";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "b5bd00db81e0e0e0ecced65c684080bb56ddc35b";
    sha256 = "10dq8dqi3jldllj6p8r9hldx9sank9n82c44w8akxrs1vli6nj3m";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc libxslt docbook_xsl ];
  buildInputs = [ pam yubikey-personalization libyubikey libykclient ];

  meta = with stdenv.lib; {
    description = "Yubico PAM module";
    homepage = "https://developers.yubico.com/yubico-pam";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
