{ lib
, buildPythonPackage
, fetchPypi
, packaging
, pytestCheckHook
, pythonOlder
, setuptools
, tomli
, wheel
}:

buildPythonPackage rec {
  pname = "pyproject-metadata";
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi rec {
    inherit pname version;
    hash = "sha256-CpTxixCLmyHzomo9VB8FbDTtyxfchyoUShVhj+1672c=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  # Many broken tests, and missing test files
  doCheck = false;

  pythonImportsCheck = [
    "pyproject_metadata"
  ];

  meta = with lib; {
    description = "PEP 621 metadata parsing";
    homepage = "https://github.com/FFY00/python-pyproject-metadata";
    changelog = "https://github.com/FFY00/python-pyproject-metadata/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh ];
  };
}
