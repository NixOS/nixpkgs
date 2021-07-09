{ cmake
, curl
, fetchFromGitLab
, lib
, libevent
, meson
, ninja
, pkg-config
, spdlog
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "coeurl";
  version = "git";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = "coeurl";
    rev = "e9010d1ce14e7163d1cb5407ed27b23303781796";
    sha256 = "1as81hmfjhnk1ghqwv815hg9wi0x177v4sghkrmczrd34sfxjhq4";
  };

  nativeBuildInputs = [
    # cmake
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    libevent
    spdlog
  ];

  # postBuild = ''
  #   find .
  #   exit 1
  # '';

  # cmakeFlags = [
  # ];

  doCheck = true;

  meta = with lib; {
    description = "A simple async wrapper around CURL for C++";
    homepage = "https://nheko.im/nheko-reborn/coeurl";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
