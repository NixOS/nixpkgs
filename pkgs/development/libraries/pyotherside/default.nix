{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  qmake,
  qtbase,
  qtdeclarative,
  qtquickcontrols ? null, # Qt6: merged into qtdeclarative
  qtsvg,
  ncurses,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "sha256-2OYVULNW9EzssqodiVtL2EmhTSbefXpLkub3zFvNwNo=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    python3
    qtbase
    (if withQt6 then qtdeclarative else qtquickcontrols)
    qtsvg
    ncurses
  ];

  dontWrapQtApps = true;

  patches = [ ./qml-path.patch ];
  installTargets = [ "sub-src-install_subtargets" ];

  meta = {
    description = "Asynchronous Python 3 Bindings for Qt ${lib.versions.major qtbase.version}";
    homepage = "https://thp.io/2011/pyotherside/";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.mic92 ];
  };
}
