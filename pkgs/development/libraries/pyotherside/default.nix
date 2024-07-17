{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  qmake,
  qtbase,
  qtquickcontrols,
  qtsvg,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "sha256-Fh0gtbBi391ZgwS68FX1zUzeuz8ayEjlwnEM8LjaB8k=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    python3
    qtbase
    qtquickcontrols
    qtsvg
    ncurses
  ];

  dontWrapQtApps = true;

  patches = [ ./qml-path.patch ];
  installTargets = [ "sub-src-install_subtargets" ];

  meta = with lib; {
    description = "Asynchronous Python 3 Bindings for Qt 5";
    homepage = "https://thp.io/2011/pyotherside/";
    license = licenses.isc;
    maintainers = [ maintainers.mic92 ];
  };
}
