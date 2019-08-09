{ stdenv, fetchFromGitHub
, python3, qmake, qtbase, qtquickcontrols, qtsvg, ncurses }:

stdenv.mkDerivation rec {
  pname = "pyotherside";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "pyotherside";
    rev = version;
    sha256 = "0dnsvyg990ln3bdjdyc5b4lbb63wcjij0skq8pb4x4jglfy7vz4z";
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
