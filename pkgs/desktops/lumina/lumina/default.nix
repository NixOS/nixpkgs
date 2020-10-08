{ stdenv
, mkDerivation
, fetchFromGitHub
, fluxbox
, libarchive
, numlockx
, qmake
, qtbase
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
, xorg
, xscreensaver
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "lumina";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bvs12c9pkc6fnkfcr7rrxc8jfbzbslch4nlfjrzwi203fcv4avw";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook
  ];

  buildInputs = [
    fluxbox # window manager for Lumina DE
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

    # Add full path of bsdtar to lumina-archiver
    substituteInPlace src-qt5/desktop-utils/lumina-archiver/TarBackend.cpp \
      --replace '"bsdtar"' '"${stdenv.lib.getBin libarchive}/bin/bsdtar"'

    # Fix desktop files
    for i in $(grep -lir 'OnlyShowIn=Lumina' src-qt5); do
      substituteInPlace $i --replace 'OnlyShowIn=Lumina' 'OnlyShowIn=X-Lumina'
    done
  '';

  qmakeFlags = [
    "LINUX_DISTRO=NixOS"
    "CONFIG+=WITH_I18N"
    "LRELEASE=${stdenv.lib.getDev qttools}/bin/lrelease"
  ];

  passthru.providedSessions = [ "Lumina-DE" ];

  meta = with stdenv.lib; {
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
