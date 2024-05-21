{ lib
, attrs
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "outcome";
  version = "1.3.0.post0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nc8C5l8pcbgAR7N3Ro5yomjhXArzzxI45v8U9/kRQ7g=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
  ];

  # Has a test dependency on trio, which depends on outcome.
  doCheck = false;

  pythonImportsCheck = [
    "outcome"
  ];

  meta = {
    description = "Capture the outcome of Python function calls";
    homepage = "https://github.com/python-trio/outcome";
    changelog = "https://github.com/python-trio/outcome/releases/tag/v${version}";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ catern ];
  };
}
