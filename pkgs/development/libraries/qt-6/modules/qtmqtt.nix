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
  version = "6.11.1";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtmqtt";
    tag = "v${version}";
    hash = "sha256-GWaF4iCPtATL1mJkPHVY0rom8R2FMNWGahE3KWBlfV8=";
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
