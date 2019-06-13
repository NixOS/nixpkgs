{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, asciidoc, libxslt, docbook_xsl
, pam, yubikey-personalization, libyubikey, libykclient }:

stdenv.mkDerivation rec {
  pname = "yubico-pam";
  version = "unstable-2019-03-19";
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = pname;
    rev = "1c6fa66825e77b3ad8df46513d0125bed9bde704";
    sha256 = "1g41wdwa1wbp391w1crbis4hwz60m3y06rd6j59m003zx40sk9s4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc libxslt docbook_xsl ];
  buildInputs = [ pam yubikey-personalization libyubikey libykclient ];

  meta = with stdenv.lib; {
    description = "Yubico PAM module";
    homepage = https://developers.yubico.com/yubico-pam;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
