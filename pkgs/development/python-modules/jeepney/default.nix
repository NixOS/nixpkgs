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
  version = "0.4.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13806f91a96e9b2623fd2a81b950d763ee471454aafd9eb6d75dbe7afce428fb";
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
