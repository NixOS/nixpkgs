{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  standard-telnetlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "plumlightpad";
  version = "0.0.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5J+kk/fn45v/1WIsBuq6o7hivXkCaJ1Of7BLRf10rCk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    standard-telnetlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "plumlightpad" ];

  meta = {
    description = "A python package that interacts with the Plum Lightpad";
    homepage = "https://github.com/heathbar/plum-lightpad-python";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
