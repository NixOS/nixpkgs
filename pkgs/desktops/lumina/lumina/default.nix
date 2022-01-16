{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, substituteAll
, acpi
, alsa-utils
, brightnessctl
, coreutils
, dbus
, fluxbox
, hicolor-icon-theme
, libarchive
, numlockx
, pavucontrol-qt
, procps
, qmake
, qtbase
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
, sysstat
, wrapGAppsHook
, xorg
, xscreensaver
}:

mkDerivation rec {
  pname = "lumina";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1llr65gilcf0k88f9mbwzlalqwdnjy4nv2jq7w154z0xmd6iarfq";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook
  ];

  buildInputs = [
    acpi
    alsa-utils
    brightnessctl
    dbus
    fluxbox # window manager for Lumina DE
    hicolor-icon-theme
    libarchive # make `bsdtar` available for lumina-archiver
    numlockx # required for changing state of numlock at login
    pavucontrol-qt
    procps
    qtbase
    qtmultimedia
    qtsvg
    qtx11extras
    sysstat
    xorg.libXcursor
    xorg.libXdamage
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilwm
    xscreensaver
  ];

  dontDropIconThemeCache = true;

  patches = [
    (fetchpatch {
      name = "Add-LuminaOS-NixOS.cpp.patch";
      url = "https://patch-diff.githubusercontent.com/raw/lumina-desktop/lumina/pull/802.patch";
      sha256 = "sha256-YgTKEvlWd3Ys9IUxcXqvrfV258mXTW/MRhWLj8pP23o=";
    })
  ];

  postPatch = ''
    # Fix file paths in NixOS distribution specific source code
    acpi="${acpi}/bin/acpi" \
      amixer="${alsa-utils}/bin/amixer" \
      brightnessctl="${brightnessctl}/bin/brightnessctl" \
      dbus_send="${dbus}/bin/dbus-send" \
      df="${coreutils}/bin/df" \
      iostat="${sysstat}/bin/iostat" \
      md5sum="${coreutils}/bin/md5sum" \
      pavucontrol_qt="${pavucontrol-qt}/bin/pavucontrol-qt" \
      top="${procps}/bin/top" \
      substituteAllInPlace {port-files/NixOS,src-qt5/core/libLumina}/LuminaOS-NixOS.cpp

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
    description = "A lightweight, portable desktop environment";
    longDescription = ''
      The Lumina Desktop Environment is a lightweight system interface
      that is designed for use on any Unix-like operating system. It
      is based on QT5.
    '';
    homepage = "https://lumina-desktop.org";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
