{ lib
, buildPythonPackage
, fetchPypi
, termcolor
, pytest
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-sugar";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1b2186b0a72aada6859bea2a5764145e3aaa2c1cfbb23c3a19b5f7b697563d3";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    termcolor
    packaging
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A plugin that changes the default look and feel of py.test";
    homepage = "https://github.com/Frozenball/pytest-sugar";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
