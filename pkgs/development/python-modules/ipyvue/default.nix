{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Python Inputs
  setuptools,
  ipywidgets,
}:

buildPythonPackage rec {
  pname = "ipyvue";
  version = "1.11.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AwgE/5GgRK0/oHrjTjlSo9IxmDdnhDSqqZrkiLp0mls=";
  };

  build-system = [ setuptools ];

  dependencies = [ ipywidgets ];

  doCheck = false; # No tests in package or GitHub
  pythonImportsCheck = [ "ipyvue" ];

  meta = with lib; {
    description = "Jupyter widgets base for Vue libraries";
    homepage = "https://github.com/mariobuikhuizen/ipyvue";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
