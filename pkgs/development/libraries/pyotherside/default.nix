{ stdenv, fetchFromGitHub
, python3, qmake, qtbase, qtquickcontrols, qtsvg, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "1mczagl7mrgw9rqxlasgybrkfigdw1g7k542q75am8gp82m6wka9";
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
