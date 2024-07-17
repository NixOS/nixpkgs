{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  ninja,
  pkg-config,
  meson,
  libevent,
  curl,
  spdlog,
}:

stdenv.mkDerivation rec {
  pname = "coeurl";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "nheko.im";
    owner = "nheko-reborn";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sN+YSddUOdnJLcnHyWdjNm1PpxCwnkwiqSvyrwUrg6w=";
  };
  patches = [
    # Fix compatibility issues with curl > 7.85, see:
    # https://nheko.im/nheko-reborn/coeurl/-/commit/d926893007c353fbc149d8538a5762ca8384273a
    # PATCH CAN BE REMOVED AFTER 0.3.0
    (fetchpatch {
      url = "https://nheko.im/nheko-reborn/coeurl/-/commit/d926893007c353fbc149d8538a5762ca8384273a.patch";
      hash = "sha256-hOBk7riuVI7k7qe/SMq3XJnFzyZ0gB9kVG7dKvWOsPY=";
    })
    # Fix error when building with fmt >= 10, see:
    # https://nheko.im/nheko-reborn/coeurl/-/commit/831e2ee8e9cf08ea1ee9736cde8370f9d0312abc
    # PATCH CAN BE REMOVED AFTER 0.3.0
    (fetchpatch {
      url = "https://nheko.im/nheko-reborn/coeurl/-/commit/831e2ee8e9cf08ea1ee9736cde8370f9d0312abc.patch";
      hash = "sha256-a52Id7Nm3Mmmwv7eL58j6xovjlkpAO4KahVM/Q3H65w=";
    })
  ];
  postPatch = ''
    substituteInPlace subprojects/curl.wrap --replace '[provides]' '[provide]'
  '';

  nativeBuildInputs = [
    ninja
    pkg-config
    meson
  ];

  buildInputs = [
    libevent
    curl
    spdlog
  ];

  meta = with lib; {
    description = "Simple async wrapper around CURL for C++";
    homepage = "https://nheko.im/nheko-reborn/coeurl";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
