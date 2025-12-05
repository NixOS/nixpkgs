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
  makeDesktopItem,
  copyDesktopItems,
  qt5,
  wrapGAppsHook3,
  USRPSupport ? false,
  uhd,
}:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.8-unstable-2025-07-31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "4979a5c94d7c0c728fa2ff3fda8f564e6ed6c7b4";
    hash = "sha256-oLtMyk9szXiHSPzEzhG58FQ2HAG4JTAPhJvk2rfycAc=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    wrapGAppsHook3
    copyDesktopItems
  ];
  buildInputs = [
    hackrf
    rtl-sdr
    airspy
    limesuite
    libiio
    libbladeRF
  ]
  ++ lib.optional USRPSupport uhd
  ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  dependencies = with python3Packages; [
    pyqt5
    numpy
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

  meta = {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
