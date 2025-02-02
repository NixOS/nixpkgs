{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  pkg-config,
  qtsvg,
  qttools,
  xdg-user-dirs,
  xkeyboard_config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-wayland-session";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-wayland-session";
    rev = version;
    hash = "sha256-5WdfwJ89HWlXL6y9Lpgs7H3mbN/wbf+9VbP9ERPasBM=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    pkg-config
    qttools
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    qtsvg
    xdg-user-dirs
  ];

  postPatch = ''
    substituteInPlace startlxqtwayland.in \
      --replace-fail /usr/share/X11/xkb/rules ${xkeyboard_config}/share/X11/xkb/rules

    substituteInPlace configurations/{labwc/autostart,lxqt-hyprland.conf,lxqt-wayfire.ini} \
      --replace-fail /usr/share/lxqt/wallpapers $out/share/lxqt/wallpapers
  '';

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-wayland-session";
    description = "Files needed for the LXQt Wayland Session";
    license = with lib.licenses; [
      bsd3
      cc-by-sa-40
      gpl2Only
      gpl3Only
      lgpl21Only
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = lib.teams.lxqt.members;
  };
}
