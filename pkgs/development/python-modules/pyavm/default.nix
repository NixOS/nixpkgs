{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  astropy,
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyavm";
  version = "0.9.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vA9gXZV8H9bXdlUj/LqLmnI3esbFFGHCqDj+RGALzZo=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    astropy
    numpy
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyavm" ];

  meta = {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "https://astrofrog.github.io/pyavm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
