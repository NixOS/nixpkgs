{
  lib,
  mkDerivation,
  fetchFromGitHub,
  fluxbox,
  hicolor-icon-theme,
  libarchive,
  numlockx,
  qmake,
  qtbase,
  qtmultimedia,
  qtsvg,
  qttools,
  qtx11extras,
  xorg,
  xscreensaver,
  wrapGAppsHook3,
}:

mkDerivation rec {
  pname = "lumina";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = "lumina";
    rev = "v${version}";
    sha256 = "1llr65gilcf0k88f9mbwzlalqwdnjy4nv2jq7w154z0xmd6iarfq";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook3
  ];

  buildInputs = [
    fluxbox # window manager for Lumina DE
    hicolor-icon-theme
    libarchive # make `bsdtar` available for lumina-archiver
    numlockx # required for changing state of numlock at login
    qtbase
    qtmultimedia
    qtsvg
    qtx11extras
    xorg.libXcursor
    xorg.libXdamage
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilwm
    xscreensaver
  ];

  dontDropIconThemeCache = true;

  patches = [
    ./LuminaOS-NixOS.cpp.patch
  ];

  prePatch = ''
    # Copy Gentoo setup as NixOS setup and then patch it
    # TODO: write a complete NixOS setup?
    cp -a src-qt5/core/libLumina/LuminaOS-Gentoo.cpp src-qt5/core/libLumina/LuminaOS-NixOS.cpp
  '';

  postPatch = ''
    # Avoid absolute path on sessdir
    substituteInPlace src-qt5/OS-detect.pri \
      --replace L_SESSDIR=/usr/share/xsessions '#L_SESSDIR=/usr/share/xsessions'

    # Fix plugin dir
    substituteInPlace src-qt5/core/lumina-theme-engine/lthemeengine.pri \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"

    # Fix location of fluxbox styles
    substituteInPlace src-qt5/core-utils/lumina-config/pages/page_fluxbox_settings.cpp \
      --replace 'LOS::AppPrefix()+"share/fluxbox' "\"${fluxbox}/share/fluxbox"

    # Add full path of bsdtar to lumina-archiver
    substituteInPlace src-qt5/desktop-utils/lumina-archiver/TarBackend.cpp \
      --replace '"bsdtar"' '"${lib.getBin libarchive}/bin/bsdtar"'

    # Fix installation path of lumina-sudo
    substituteInPlace src-qt5/desktop-utils/lumina-sudo/lumina-sudo.pro \
      --replace "/usr/bin" "$out/bin"
  '';

  postInstall = ''
    for theme in lumina-icons material-design-{dark,light}; do
      gtk-update-icon-cache $out/share/icons/$theme
    done
  '';

  qmakeFlags = [
    "LINUX_DISTRO=NixOS"
    "CONFIG+=WITH_I18N"
    "LRELEASE=${lib.getDev qttools}/bin/lrelease"
  ];

  passthru.providedSessions = [ "Lumina-DE" ];

  meta = with lib; {
    description = "Lightweight, portable desktop environment";
    longDescription = ''
      The Lumina Desktop Environment is a lightweight system interface
      that is designed for use on any Unix-like operating system. It
      is based on QT5.
    '';
    homepage = "https://lumina-desktop.org";
    license = licenses.bsd3;
    platforms = platforms.unix;
    teams = [ teams.lumina ];
  };
}
