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
  version = "2.9.8-unstable-2025-07-07";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = "urh";
    rev = "9061187d326f39de126dd1b8cc943aa33c36ae8d";
    hash = "sha256-MjgEa33geZ8Icn7H/Zxvux6rMnSOFcMuwG5n/5cwuMI=";
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

  meta = with lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
