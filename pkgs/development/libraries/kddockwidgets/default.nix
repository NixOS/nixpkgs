{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qtbase,
  qtdeclarative,
  qtquickcontrols2,
  qtx11extras,
  spdlog,
  fmt,
  nlohmann_json,
}:

stdenv.mkDerivation rec {
  pname = "KDDockWidgets";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DxRySKhQ15OpstjCO6FJ9edV7z8/rECN2+o5T63vFzQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    spdlog
    fmt
    nlohmann_json
  ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtquickcontrols2
    qtx11extras
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDAB's Dock Widget Framework for Qt";
    homepage = "https://www.kdab.com/development-resources/qt-tools/kddockwidgets";
    license = with licenses; [
      gpl2Only
      gpl3Only
    ];
    maintainers = with maintainers; [ _1000teslas ];
  };
}
