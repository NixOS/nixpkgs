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

  meta = with lib; {
    description = "Platform library for libcec and Kodi addons";
    homepage = "https://github.com/Pulse-Eight/platform";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}
