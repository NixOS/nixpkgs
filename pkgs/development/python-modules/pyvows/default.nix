{
  lib,
  buildPythonPackage,
  fetchPypi,
  gevent,
  preggy,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyvows";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pyVows";
    inherit version;
    hash = "sha256-2+4umWLNkbFlCpfFwX0FA2N0zOZhst/YM4ozBfXoaMI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gevent
    preggy
  ];

  pythonImportsCheck = [ "pyvows" ];

  checkPhase = ''
    ${python.interpreter} pyvows/cli.py tests/
  '';

  meta = {
    description = "BDD test engine based on Vows.js";
    homepage = "https://github.com/heynemann/pyvows";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joachimschmidt557 ];
  };
}
