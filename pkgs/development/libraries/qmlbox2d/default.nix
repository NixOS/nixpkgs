{
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  fetchFromGitHub,
  cmake,
  pkg-config,
  box2d,
  unstableGitUpdater,
}:

let
  inherit (lib) cmakeBool;

  # 2.3.1 is the only supported version
  box2d' = box2d.overrideAttrs (old: rec {
    version = "2.3.1";
    src = fetchFromGitHub {
      owner = "erincatto";
      repo = "box2d";
      tag = "v${version}";
      hash = "sha256-Z2J17YMzQNZqABIa5eyJDT7BWfXveymzs+DWsrklPIs=";
    };
    patches = [ ];
    postPatch = "";
    sourceRoot = "${src.name}/Box2D";
    cmakeFlags = old.cmakeFlags or [ ] ++ [
      (cmakeBool "BOX2D_INSTALL" true)
      (cmakeBool "BOX2D_BUILD_SHARED" true)
      (cmakeBool "BOX2D_BUILD_EXAMPLES" false)
    ];
  });

in
stdenv.mkDerivation {
  pname = "qml-box2d";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "qml-box2d";
    repo = "qml-box2d";
    rev = "3a85439726d1ac4d082308feba45f23859ba71e0";
    hash = "sha256-lTgzPJWSwNfPRj5Lc63C69o4ILuyhVRLvltTo5E7yq0=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    box2d'
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    (cmakeBool "USE_SYSTEM_BOX2D" true)
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      hardcodeZeroVersion = true;
    };
  };

  meta = {
    description = "QML plugin for Box2D engine";
    homepage = "https://github.com/qml-box2d/qml-box2d";
    maintainers = with lib.maintainers; [ guibou ];
    platforms = lib.platforms.linux;
    license = lib.licenses.zlib;
  };
}
