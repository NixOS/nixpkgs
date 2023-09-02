{ lib
, isPy27
, buildPythonPackage
, fetchPypi
  # Python Inputs
, ipywidgets
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.10.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XPmrGg0SCTiZKMeTCeJywuKaa5ByY9FQTBy+THSJSiQ=";
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
