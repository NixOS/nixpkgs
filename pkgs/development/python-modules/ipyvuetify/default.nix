{ lib
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipyvue
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
  version = "1.8.10";
  format = "setuptools";

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m6RCeUefM/XLg69AaqgTBQ7pYgGVXCy6CH/SOoQ9W04=";
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
