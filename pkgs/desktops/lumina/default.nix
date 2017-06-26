{ stdenv, fetchFromGitHub, fluxbox, xscreensaver, desktop_file_utils, numlockx,
  xorg, qtbase, qtsvg, qtmultimedia, qtx11extras, qmake, qttools, oxygen-icons5
}:

stdenv.mkDerivation rec {
  name = "lumina-${version}";
  version = "1.2.0-p1";

  src = fetchFromGitHub {
    owner = "trueos";
    repo = "lumina";
    rev = "v${version}";
    sha256 = "0k16lcpxp9avwkadbbyqficd1wxsmwian5ji38wyax76v22yq7p6";
  };

  nativeBuildInputs = [
    qmake
    qttools
  ];

  buildInputs = [
    xorg.libxcb
    xorg.xcbutilwm
    xorg.xcbutilimage
    qtbase
    qtsvg
    qtmultimedia
    qtx11extras
    oxygen-icons5
    fluxbox
    xscreensaver
    desktop_file_utils
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
    # Fix location of fluxbox styles
    substituteInPlace src-qt5/core-utils/lumina-config/pages/page_fluxbox_settings.cpp \
      --replace 'LOS::AppPrefix()+"share/fluxbox' "\"${fluxbox}/share/fluxbox"
  '';

  qmakeFlags = [ "LINUX_DISTRO=NixOS" "CONFIG+=WITH_I18N" ];

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
