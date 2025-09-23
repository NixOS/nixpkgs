{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "p8-platform";
  version = "2.1.0.1";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "platform";
    rev = "p8-platform-${version}";
    sha256 = "sha256-zAI/AOLJAunv+cCQ6bOXrgkW+wl5frj3ktzx2cDeCCk=";
  };

  nativeBuildInputs = [ cmake ];

  # Fixes "no member named 'ptr_fun' in the global namespace" in src/util/StringUtils.cpp
  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_CXX_FLAGS='-std=c++11'";

  meta = with lib; {
    description = "Platform library for libcec and Kodi addons";
    homepage = "https://github.com/Pulse-Eight/platform";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.kodi ];
  };
}
