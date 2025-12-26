{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "2.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-acaonyt7CKMEDX7Soe7MujejHdyS+hmTOcU6KuPEjDQ=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${version}/CHANGES.rst";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
