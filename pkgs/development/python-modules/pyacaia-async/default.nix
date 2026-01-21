{
  lib,
  bleak,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyacaia-async";
  version = "0.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "pyacaia_async";
    inherit version;
    hash = "sha256-RwiASn6mD6BhZByoHVqaCH7koVhN5wQorG2l51wFAcI=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ bleak ];

  # Module has no tests in PyPI releases
  doCheck = false;

  pythonImportsCheck = [ "pyacaia_async" ];

  meta = {
    description = "Module to interact with Acaia scales";
    homepage = "https://github.com/zweckj/pyacaia_async";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
