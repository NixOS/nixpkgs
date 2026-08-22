{
  qtModule,
  fetchFromGitHub,
  qtbase,
  qtdeclarative,
  qtwebsockets,
  pkgsBuildBuild,
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.11.2";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-Xg4vfVfYgruRXB6LSWFJWSMtsClJMtML+KhaQExWUGs=";
  };

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtwebsockets
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
