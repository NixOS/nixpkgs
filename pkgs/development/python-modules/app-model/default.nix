{ lib
, buildPythonPackage
, fetchFromGitHub
, in-n-out
, psygnal
, pydantic
, pytestCheckHook
, pythonOlder
, typing-extensions
, setuptools-scm
, setuptools
}:

buildPythonPackage rec {
  pname = "app-model";
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nZnIb2QHfpkPirjQPiBdLd7pc1NNn97fdjGxKs0lWQU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    psygnal
    pydantic
    in-n-out
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "app_model"
  ];

  meta = with lib; {
    description = "Module to implement generic application schema";
    homepage = "https://github.com/pyapp-kit/app-model";
    changelog = "https://github.com/pyapp-kit/app-model/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
