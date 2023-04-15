{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, qmake
, qtbase
, qtsvg
, qtx11extras ? null
, kwindowsystem ? null
, libX11
, libXext
, qttools
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    rev = "V${version}";
    sha256 = "5/cScJpi5Z5Z/SjizKfMTGytuEo2uUT6QtpMnn7JhKc=";
  };

  nativeBuildInputs = [
    qttools
    wrapQtAppsHook
  ] ++ (lib.optionals (lib.versionOlder qtbase.version "6") [
    qmake
  ]) ++ (lib.optionals (lib.versionAtLeast qtbase.version "6") [
    cmake
  ]);

  buildInputs = [
    qtbase
    qtsvg
    libX11
    libXext
  ] ++ (lib.optionals (lib.versionOlder qtbase.version "6") [
    kwindowsystem
    qtx11extras
  ]);

  sourceRoot = "source/Kvantum";

  cmakeFlags = lib.optional (lib.versionAtLeast qtbase.version "6") "-DENABLE_QT5=OFF";

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
    sed -i style/CMakeLists.txt -e "s#set(KVANTUM_STYLE_DIR .*)#set(KVANTUM_STYLE_DIR \"$out/$qtPluginPrefix/styles/\")#g"

    # Install themes for Qt6
    substituteInPlace CMakeLists.txt \
      --replace 'if(ENABLE_QT5)' $'add_subdirectory(themes)\nif(ENABLE_QT5)'
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "V";
  };

  meta = with lib; {
    description = "SVG-based Qt5 theme engine plus a config tool and extra themes";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
