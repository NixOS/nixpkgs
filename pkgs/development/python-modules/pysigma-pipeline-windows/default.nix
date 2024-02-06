{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysigma-pipeline-windows";
  version = "1.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    rev = "refs/tags/v${version}";
    hash = "sha256-279+nP5IeZiIjKNhJ2adbcJSDzcu7yqIB5JNFK5CPF0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.windows"
  ];

  meta = with lib; {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    changelog = "https://github.com/SigmaHQ/pySigma-pipeline-windows/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
