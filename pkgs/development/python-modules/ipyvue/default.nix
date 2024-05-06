{ lib
, isPy27
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.11.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ez2ygBvgU12FX/+qDkARlizq50rEgZYp4UH5Sx4E2QA=";
  };

  propagatedBuildInputs = [ ipywidgets ];

  doCheck = false;  # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = with lib; {
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
