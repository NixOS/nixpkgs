{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  jansson,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "libjwt";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
    sha256 = "sha256-yMnk4gfUa5c6Inppz9I1h6it41nuJ4By3eDO0YrdB2Y=";
  };

  buildInputs = [
    jansson
    openssl
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    homepage = "https://github.com/benmcollins/libjwt";
    description = "JWT C Library";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pnotequalnp ];
    platforms = platforms.all;
  };
}
