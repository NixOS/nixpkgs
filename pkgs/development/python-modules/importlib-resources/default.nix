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
  version = "5.8.0";
  format = "pyproject";
  disabled = isPy27;

  src = fetchPypi {
    pname = "importlib_resources";
    inherit version;
    sha256 = "sha256-VoyfFssgT53syNbSSlcu7qJ9rLtM7p5rA6gCVzZ2l1E=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
  ] ++ lib.optional (pythonOlder "3.5") [
    typing
  ];

  checkInputs = [
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
