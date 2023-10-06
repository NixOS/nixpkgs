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
  version = "5.12.0";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    hash = "sha256-S+glib9cHXmZrt8qRRWdEMs8pPGbInH4eSvI5tp7IvY=";
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
