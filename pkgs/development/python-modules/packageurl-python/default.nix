{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "packageurl-python";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8hmyzmNIGFonvWpy5v3J+YTmyfoVfv+ny5PjQcSc3MI=";
  };

  build-system = [
    setuptools
  ];

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
