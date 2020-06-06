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
  version = "0.4.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3479b861cc2b6407de5188695fa1a8d57e5072d7059322469b62628869b8e36e";
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
    homepage = "https://gitlab.com/takluyver/jeepney";
    description = "Pure Python DBus interface";
    license = licenses.mit;
  };
}
