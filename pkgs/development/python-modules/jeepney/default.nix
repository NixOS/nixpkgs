{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, testpath
, tornado
}:

buildPythonPackage rec {
  pname = "jeepney";
  version = "0.4";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w1w1rawl9k4lx91w16d19kbmf1349mhy8ph8x3w0qp1blm432b0";
  };

  propagatedBuildInputs = [
    tornado
  ];

  checkInputs = [
    pytest
    testpath
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://gitlab.com/takluyver/jeepney;
    description = "Pure Python DBus interface";
    license = licenses.mit;
  };
}
