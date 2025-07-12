{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  thunar,
  cmake,
  ninja,
  xfce,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "thunar-dropbox";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Jeinzi";
    repo = "thunar-dropbox";
    rev = version;
    sha256 = "sha256-uYqO87ftEtnSRn/yMSF1jVGleYXR3hVj2Jb1/kAd64Y=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
  ];

  buildInputs = [
    thunar
    gtk3
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/Jeinzi/thunar-dropbox";
    description = "Plugin that adds context-menu items for Dropbox to Thunar";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    teams = [ teams.xfce ];
  };
}
