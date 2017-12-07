{ buildPythonPackage, fetchPypi, python
, pytest, pytestcov, watchdog, mock
}:

buildPythonPackage rec {
  pname = "hupper";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02lj6kgaf9xpr0binxwac3gpdhljglyj9fr78s165jc7qd7mifdg";
  };

  checkPhase = ''
    py.test
  '';

  checkInputs = [ pytest pytestcov watchdog mock ];
}
