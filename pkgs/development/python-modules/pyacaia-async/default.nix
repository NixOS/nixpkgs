{ lib
, bleak
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "pyacaia-async";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "pyacaia_async";
    inherit version;
    hash = "sha256-9aZmlw+u4fUa+TRh1COmViWAUQQ0MN2nFKY0t1hS+ko=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bleak
  ];

  # Module has no tests in PyPI releases
  doCheck = false;

  pythonImportsCheck = [
    "pyacaia_async"
  ];

  meta = with lib; {
    description = "Module to interact with Acaia scales";
    homepage = "https://github.com/zweckj/pyacaia_async";
    license = with licenses; [ gpl3Only mit ];
    maintainers = with maintainers; [ fab ];
  };
}
