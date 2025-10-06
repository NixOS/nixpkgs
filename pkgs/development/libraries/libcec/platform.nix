{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "p8-platform";
  version = "2.1.0.1";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "platform";
    rev = "p8-platform-${version}";
    hash = "sha256-zAI/AOLJAunv+cCQ6bOXrgkW+wl5frj3ktzx2cDeCCk=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    # required for cmake 4 support
    (fetchpatch {
      name = "libcec-platform-fix-cmake4-1.patch";
      url = "https://github.com/Pulse-Eight/platform/commit/7350df98980b4e7036812b15812e3cb3c9353816.patch";
      includes = [ "CMakeLists.txt" ];
      hash = "sha256-YbxQxmXF2Iv67SjX/kMD9Df2nggBFX0fBFMyNdXXZtI=";
    })
    # required for cmake 4 support
    (fetchpatch {
      name = "libcec-platform-fix-cmake4-5.patch";
      url = "https://github.com/Pulse-Eight/platform/commit/d7faed1c696b1a6a67f114a63a0f4c085f0f9195.patch";
      includes = [ "CMakeLists.txt" ];
      hash = "sha256-T+quL5wxc1w+KyNGxW443Ud+r6FVPej6jN6oXQ5pkRs=";
    })
  ];

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_CXX_FLAGS='-std=c++11'";

  meta = with lib; {
    description = "Platform library for libcec and Kodi addons";
    homepage = "https://github.com/Pulse-Eight/platform";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.kodi ];
  };
}
