{ lib, fetchPypi, buildPythonPackage, nose }:

buildPythonPackage rec {
  version = "1.11";
  pname = "python-stdnum";
  src = fetchPypi {
    inherit pname version;
    sha256 = "d5f0af1bee9ddd9a20b398b46ce062dbd4d41fcc9646940f2667256a44df3854";
  };

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = {
    homepage = https://arthurdejong.org/python-stdnum/;
    description = "Python module to handle standardized numbers and codes";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.lgpl2Plus;
  };
}
