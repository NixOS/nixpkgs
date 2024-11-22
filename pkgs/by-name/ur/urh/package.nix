{ stdenv, lib, fetchFromGitHub, python3Packages
, hackrf, rtl-sdr, airspy, limesuite, libiio
, libbladeRF
, imagemagick
, makeDesktopItem
, copyDesktopItems
, qt5
, wrapGAppsHook3
, USRPSupport ? false, uhd }:

python3Packages.buildPythonApplication rec {
  pname = "urh";
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "jopohl";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-r3d80dzGwgf5Tuwt1IWGcmNbblwBNKTKKm+GGx1r2HE=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook wrapGAppsHook3 copyDesktopItems
                        imagemagick # for scaling icons
                      ];
  buildInputs = [ hackrf rtl-sdr airspy limesuite libiio libbladeRF ]
    ++ lib.optional USRPSupport uhd
    ++ lib.optional stdenv.hostPlatform.isLinux qt5.qtwayland;

  propagatedBuildInputs = with python3Packages; [
    pyqt5 numpy psutil cython pyzmq pyaudio setuptools
  ];

  # dont double wrap
  # https://nixos.org/manual/nixpkgs/stable/#ssec-gnome-common-issues-double-wrapped
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapQtApp $out/bin/urh
  '';

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "urh";
      icon = "urh";
      desktopName = "Universal Radio Hacker";
      categories = [ "Network" "HamRadio" ];
      comment = meta.description;
    })
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/{48x48,128x128}/apps
    convert $src/data/icons/appicon.png -resize 48x48 $out/share/icons/hicolor/48x48/apps/urh.png
    convert $src/data/icons/appicon.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/urh.png
  '';

  meta = with lib; {
    homepage = "https://github.com/jopohl/urh";
    description = "Universal Radio Hacker: investigate wireless protocols like a boss";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
