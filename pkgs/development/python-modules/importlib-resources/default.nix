{ lib
, isPy27
, buildPythonPackage
, fetchPypi
, setuptools-scm
, importlib-metadata
, typing ? null
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "importlib-resources";
  version = "5.10.2";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "sha256-5KlsjMAzlkf/ml4FUNnydvxaAf+idgErWOwQjP17hIQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.5") [
    typing
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "importlib_resources"
  ];

  meta = with lib; {
    description = "Read resources from Python packages";
    homepage = "https://importlib-resources.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
