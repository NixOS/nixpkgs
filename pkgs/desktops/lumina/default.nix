{ stdenv, fetchFromGitHub, fluxbox, xscreensaver, desktop-file-utils,
  numlockx, xorg, qtbase, qtsvg, qtmultimedia, qtx11extras, qmake,
  qttools, poppler_qt5, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "lumina-${version}";
  version = "1.4.0-p1";

  src = fetchFromGitHub {
    owner = "trueos";
    repo = "lumina";
    rev = "v${version}";
    sha256 = "0jin0a2s6pjbpw7w1bz67dgqp0xlpw1a7nh8zv0qwdf954zczanp";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook
  ];

  buildInputs = [
    xorg.libxcb
    xorg.libXdamage
    xorg.xcbutilwm
    xorg.xcbutilimage
    qtbase
    qtsvg
    qtmultimedia
    qtx11extras
    poppler_qt5
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
    # Fix location of poppler-qt5.h
    substituteInPlace src-qt5/desktop-utils/lumina-pdf/mainUI.h \
      --replace '#include <poppler-qt5.h>' '#include <poppler/qt5/poppler-qt5.h>'

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

  enableParallelBuilding = true;

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
