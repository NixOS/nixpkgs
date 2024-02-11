{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, qmake
, qtbase
, qtsvg
, qtx11extras ? null
, kwindowsystem ? null
, qtwayland
, libX11
, libXext
, qttools
, wrapQtAppsHook
, gitUpdater

, qt5Kvantum ? null
}:
let
  isQt6 = lib.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum${lib.optionalString isQt6 "6"}";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "48Blio8qHLmXSKG0c1tphXSfiwQXs0Xqwxe187nM3Ro=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    libX11
    libXext
  ] ++ lib.optionals (!isQt6) [ qtx11extras kwindowsystem ]
    ++ lib.optional isQt6 qtwayland;

  sourceRoot = "${src.name}/Kvantum";

  patches = [
    (fetchpatch {
      # add xdg dirs support
      url = "https://github.com/tsujan/Kvantum/commit/01989083f9ee75a013c2654e760efd0a1dea4a68.patch";
      hash = "sha256-HPx+p4Iek/Me78olty1fA0dUNceK7bwOlTYIcQu8ycc=";
      stripLen = 1;
    })
  ];

  postPatch = ''
    # Fix plugin dir
    substituteInPlace style/style.pro \
      --replace "\$\$[QT_INSTALL_PLUGINS]" "$out/$qtPluginPrefix"
  '';

  postInstall = lib.optionalString isQt6 ''
    # make default Kvantum themes available for Qt 6 apps
    mkdir -p "$out/share"
    ln -s "${qt5Kvantum}/share/Kvantum" "$out/share/Kvantum"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "V";
  };

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo Scrumplex ];
  };
}
