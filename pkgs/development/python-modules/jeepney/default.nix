{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytest
, testpath
, tornado
, trio
}:

buildPythonPackage rec {
  pname = "jeepney";
  version = "0.6.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d59b6622675ca9e993a6bd38de845051d315f8b0c72cca3aef733a20b648657";
  };

  propagatedBuildInputs = [
    tornado
  ];

  checkInputs = [
    pytest
    testpath
    trio
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
