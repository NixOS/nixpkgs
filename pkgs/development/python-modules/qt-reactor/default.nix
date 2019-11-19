{
  lib, buildPythonPackage, fetchFromGitHub,
  twisted, qtpy, pyqt5
}:

buildPythonPackage rec {
  pname = "qt-reactor";
  version = "364b3f561fb0d4d3938404d869baa4db7a982bf0";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = pname;
    rev = version;
    sha256 = "1nb5iwg0nfz86shw28a2kj5pyhd4jvvxhf73fhnfbl8scgnvjv9h";
  };

  propagatedBuildInputs = [
    twisted qtpy
  ];

  checkInputs = [
    pyqt5
  ];

  meta = with lib; {
    homepage = https://github.com/frmdstryr/qt-reactor;
    description = "Twisted and PyQt5 eventloop integration";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
