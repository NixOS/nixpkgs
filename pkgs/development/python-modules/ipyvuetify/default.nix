{ lib
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipyvue
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
  version = "1.8.3";

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JHeH8AFc3uThLbHV0jQexuHouDcZj+/4u4+dQ9akoq8=";
  };

  propagatedBuildInputs = [ ipyvue ];

  doCheck = false;  # no tests on PyPi/GitHub
  pythonImportsCheck = [ "ipyvuetify" ];

  meta = with lib; {
    description = "Jupyter widgets based on Vuetify UI Components.";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
