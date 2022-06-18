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
  version = "0.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-pipeline-windows";
    rev = "refs/tags/v${version}";
    hash = "sha256-ATDWhHY9tjuQbfIFgoGhz8qsluH9hTSI9zdPmP8GPWE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pysigma = "^0.5.0"' 'pysigma = "^0.6.0"'
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sigma.pipelines.windows"
  ];

  meta = with lib; {
    description = "Library to support Windows service pipeline for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-pipeline-windows";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
