{ lib, buildPythonPackage, fetchPypi, isPy3k, six, mock, nose, setuptools }:

buildPythonPackage rec {
  pname = "ansi2html";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f124ea7efcf3f24f1f9398e527e688c9ae6eab26b0b84e1299ef7f94d92c596";
  };

  propagatedBuildInputs = [ six setuptools ];

  checkInputs = [ mock nose ];

  meta = with lib; {
    description = "Convert text with ANSI color codes to HTML";
    homepage = "https://github.com/ralphbean/ansi2html";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.all;
  };
}
