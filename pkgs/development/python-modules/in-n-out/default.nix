{ lib
, buildPythonPackage
, cython_3
, fetchPypi
, future
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "in-n-out";
  version = "0.1.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PuzjidORMFVlmFZbmnu9O92FoiuXrC8NNRyjwdodriY=";
  };

  nativeBuildInputs = [
    cython_3
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "in_n_out"
  ];

  meta = with lib; {
    description = "Module for dependency injection and result processing";
    homepage = "https://app-model.readthedocs.io/";
    changelog = "https://github.com/pyapp-kit/in-n-out/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
