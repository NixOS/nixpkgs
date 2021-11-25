{ lib
, mkDerivation
, fetchFromGitHub
, fluxbox
, libarchive
, linux-pam
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
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "lumina-desktop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wc8frhw1yv07n05r33c4zilq5lgn5gw07a9n37g6nyn5sgrbp4f";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapGAppsHook
  ];

  buildInputs = [
    fluxbox # window manager for Lumina DE
    libarchive # make `bsdtar` available for lumina-archiver
    linux-pam
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

    # Do not set special permission
    substituteInPlace src-qt5/core/lumina-checkpass/lumina-checkpass.pro \
      --replace "chmod 4555" "chmod 555"

    # Fix plugin dir
    substituteInPlace src-qt5/core/lumina-theme-engine/lthemeengine.pri \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"

    # Fix location of fluxbox styles
    substituteInPlace src-qt5/core-utils/lumina-config/pages/page_fluxbox_settings.cpp \
      --replace 'LOS::AppPrefix()+"share/fluxbox' "\"${fluxbox}/share/fluxbox"

    # Add full path of bsdtar to lumina-archiver
    substituteInPlace src-qt5/desktop-utils/lumina-archiver/TarBackend.cpp \
      --replace '"bsdtar"' '"${lib.getBin libarchive}/bin/bsdtar"'

    # Fix desktop files
    for i in $(grep -lir 'OnlyShowIn=Lumina' src-qt5); do
      substituteInPlace $i --replace 'OnlyShowIn=Lumina' 'OnlyShowIn=X-Lumina'
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
