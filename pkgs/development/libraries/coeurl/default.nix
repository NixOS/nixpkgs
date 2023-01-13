{ lib
, stdenv
, fetchFromGitLab
, ninja
, pkg-config
, meson
, libevent
, curl
, spdlog
}:

stdenv.mkDerivation rec {
  pname = "coeurl";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sN+YSddUOdnJLcnHyWdjNm1PpxCwnkwiqSvyrwUrg6w=";
  };

  nativeBuildInputs = [ ninja pkg-config meson ];
  buildInputs = [ libevent curl spdlog ];

  meta = with lib; {
    description = "A simple async wrapper around CURL for C++";
    homepage = "https://nheko.im/nheko-reborn/coeurl";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
