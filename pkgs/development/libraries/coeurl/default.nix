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
  version = "0.2.1";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+FIxi019+jnjpo4NhBQ4tb3ObLrEStMN5YD+MrTLa2E=";
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
