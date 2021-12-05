{ lib, stdenv, fetchFromGitLab, ninja, pkg-config, meson, libevent, curl, spdlog
}:

stdenv.mkDerivation rec {
  pname = "coeurl";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = pname;
    rev = "v${version}";
    sha256 = "10a5klr44m2xy6law8s3s5rynk1q268fa4pkhilbn52yyv0fwajq";
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
