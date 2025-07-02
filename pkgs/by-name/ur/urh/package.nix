{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  hackrf,
  rtl-sdr,
  airspy,
  limesuite,
  libiio,
  libbladeRF,
  imagemagick,
  makeDesktopItem,
  copyDesktopItems,
  qt5,
  wrapGAppsHook3,
  USRPSupport ? false,
  uhd,
}:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    tag = "v${version}";
    hash = "sha256-r3d80dzGwgf5Tuwt1IWGcmNbblwBNKTKKm+GGx1r2HE=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    wrapGAppsHook3
    copyDesktopItems
  ];
  buildInputs =
    [
      hackrf
      rtl-sdr
      airspy
      limesuite
      libiio
      libbladeRF
    ]
    ++ lib.optional USRPSupport uhd
    ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  propagatedBuildInputs = with python3Packages; [
    pyqt5
    numpy_1
    psutil
    cython
    pyzmq
    pyaudio
    setuptools
  ];

  # dont double wrap
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;
  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      ''${qtWrapperArgs[@]}
    )
  '';

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "urh";
      exec = "urh";
      icon = "urh";
      desktopName = "Universal Radio Hacker";
      categories = [
        "Network"
        "HamRadio"
      ];
      comment = meta.description;
    })
  ];

  postInstall = ''
    install -Dm644 data/icons/appicon.png $out/share/pixmaps/urh.png
  '';

  meta = with lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
