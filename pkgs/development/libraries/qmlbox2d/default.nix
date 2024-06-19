{ lib, stdenv, qtbase, qtdeclarative, fetchFromGitHub, cmake, pkg-config, box2d }:

let
  inherit (lib) cmakeBool;

  # 2.3.1 is the only supported version
  box2d' = (box2d.override { settingsFile = "Box2D/Common/b2Settings.h"; }).overrideAttrs (old: rec {
    version = "2.3.1";
    src = fetchFromGitHub {
      owner = "erincatto";
      repo = "box2d";
      rev = "v${version}";
      hash = "sha256-Z2J17YMzQNZqABIa5eyJDT7BWfXveymzs+DWsrklPIs=";
    };
    sourceRoot = "source/Box2D";
    cmakeFlags = old.cmakeFlags or [ ] ++ [
      (cmakeBool "BOX2D_INSTALL" true)
      (cmakeBool "BOX2D_BUILD_SHARED" true)
      (cmakeBool "BOX2D_BUILD_EXAMPLES" false)
    ];
  });

in
stdenv.mkDerivation {
  pname = "qml-box2d";
  version = "unstable-2022-08-25";

  src = fetchFromGitHub {
    owner = "qml-box2d";
    repo = "qml-box2d";
    rev = "0bb88a6f871eef72b3b9ded9329c15f1da1f4fd7";
    hash = "sha256-sfSVetpHIAIujpgjvRScAkJRlQQYjQ/yQrkWvp7Yu0s=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ box2d' qtbase qtdeclarative ];

  cmakeFlags = [
    (cmakeBool "USE_SYSTEM_BOX2D" true)
  ];

  meta = with lib; {
    description = "A QML plugin for Box2D engine";
    homepage = "https://github.com/qml-box2d/qml-box2d";
    maintainers = with maintainers; [ guibou ];
    platforms = platforms.linux;
    license = licenses.zlib;
  };
}
