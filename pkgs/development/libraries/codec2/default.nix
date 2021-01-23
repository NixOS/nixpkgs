{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    sha256 = "1jpvr7bra8srz8jvnlbmhf8andbaavq5v01qjnp2f61za93rzwba";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "http://www.rowetel.com/blog/?page_id=452";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
