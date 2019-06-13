{ stdenv, fetchFromGitHub
, python3, qmake, qtbase, qtquickcontrols, qtsvg, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "1cjx0fbrq9qvbirwy76pw1f5skm2afd51k4qb269ql4gpl67d5lv";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [
    python3 qtbase qtquickcontrols qtsvg ncurses
  ];

  patches = [ ./qml-path.patch ];
  installTargets = [ "sub-src-install_subtargets" ];

  meta = with stdenv.lib; {
    description = "Asynchronous Python 3 Bindings for Qt 5";
    homepage = https://thp.io/2011/pyotherside/;
    license = licenses.isc;
    maintainers = [ maintainers.mic92 ];
  };
}
