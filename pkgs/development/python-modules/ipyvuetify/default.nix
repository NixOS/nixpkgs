{ lib
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipyvue
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
  version = "1.5.1";

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
    sha256 = "593f5d6761e304cbb78bca967030485d8835e8d310ef7d83ac1b0e6a13e4911c";
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
