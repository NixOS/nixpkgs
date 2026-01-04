{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-session,
  pkg-config,
  qtsvg,
  qttools,
  qtxdg-tools,
  xdg-user-dirs,
  xkeyboard_config,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-wayland-session";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-wayland-session";
    rev = version;
    hash = "sha256-MmiYPclMW8Y9VMZsY8wx52S3fN3RzUVrhQAGs5qSTfI=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    pkg-config
    qttools
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt # for applications that need layer-shell-qt (ex: lxqt-panel)
    liblxqt
    libqtxdg
    lxqt-session
    qtsvg
    qtxdg-tools # allow to use xdg-utils under LXQt, similar to https://github.com/lxqt/lxqt-session/blob/2.0.0/CHANGELOG#L27
    xdg-user-dirs # startlxqtwayland sets XDG_CURRENT_DESKTOP
  ];

  postPatch = ''
    substituteInPlace startlxqtwayland.in \
      --replace-fail /usr/share/X11/xkb/rules ${xkeyboard_config}/share/X11/xkb/rules \
      --replace-fail "cp -av " "cp -av --no-preserve=mode "

    substituteInPlace configurations/{labwc/autostart,lxqt-hyprland.conf,lxqt-wayfire.ini} \
      --replace-fail /usr/share/lxqt/wallpapers $out/share/lxqt/wallpapers
  '';

  dontWrapQtApps = true;

  passthru.updateScript = gitUpdater { };

  passthru.providedSessions = [ "lxqt-wayland" ];

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
    teams = [ lib.teams.lxqt ];
  };
}
