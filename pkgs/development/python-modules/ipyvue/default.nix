{ lib
, isPy27
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.9.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2j8qYRXR8nmV5++g4OJn65dq3lypgqo9oxBscNb4eNs=";
  };

  propagatedBuildInputs = [ ipywidgets ];

  doCheck = false;  # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = with lib; {
    description = "Jupyter widgets base for Vue libraries.";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
