{ stdenv,
  fetchFromGitHub,
  desktop-file-utils,
  fluxbox,
  numlockx,
  qmake,
  qtbase,
  qtmultimedia,
  qtsvg,
  qttools,
  qtx11extras,
  xorg,
  xscreensaver,
  wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "lumina";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rj2gzifr98db7i82cg3hg7l5yfik810pjpawg6n54qbzq987z25";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook
  ];

  buildInputs = [
    xorg.libxcb
    xorg.libXcursor
    xorg.libXdamage
    xorg.xcbutilwm
    xorg.xcbutilimage
    qtbase
    qtsvg
    qtmultimedia
    qtx11extras
    fluxbox
    xscreensaver
    desktop-file-utils
    numlockx
  ];

  patches = [
    ./avoid-absolute-path-on-sessdir.patch
    ./LuminaOS-NixOS.cpp.patch
  ];

  prePatch = ''
    # Copy Gentoo setup as NixOS setup and then patch it
    # TODO: write a complete NixOS setup?
    cp -a src-qt5/core/libLumina/LuminaOS-Gentoo.cpp src-qt5/core/libLumina/LuminaOS-NixOS.cpp
  '';

  postPatch = ''
    # Fix plugin dir
    substituteInPlace src-qt5/core/lumina-theme-engine/lthemeengine.pri \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"

    # Fix location of fluxbox styles
    substituteInPlace src-qt5/core-utils/lumina-config/pages/page_fluxbox_settings.cpp \
      --replace 'LOS::AppPrefix()+"share/fluxbox' "\"${fluxbox}/share/fluxbox"
  '';

  qmakeFlags = [
    "LINUX_DISTRO=NixOS"
    "CONFIG+=WITH_I18N"
    "LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease"
  ];

  meta = with stdenv.lib; {
    description = "A lightweight, portable desktop environment";
    longDescription = ''
      The Lumina Desktop Environment is a lightweight system interface
      that is designed for use on any Unix-like operating system. It
      is based on QT5.
    '';
    homepage = https://lumina-desktop.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
