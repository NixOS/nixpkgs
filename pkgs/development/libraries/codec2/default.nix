{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    sha256 = "sha256-R4H6gwmc8nPgRfhNms7n7jMCHhkzX7i/zfGT4CYSsY8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "http://www.rowetel.com/blog/?page_id=452";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
