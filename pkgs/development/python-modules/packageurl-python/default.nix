{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hPgFP0uFKUuYs7eHFUdYR/tI9FJewwLQbcNbJqmzB4o=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "packageurl"
  ];

  meta = with lib; {
    description = "Python parser and builder for package URLs";
    homepage = "https://github.com/package-url/packageurl-python";
    changelog = "https://github.com/package-url/packageurl-python/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ armijnhemel ];
  };
}
