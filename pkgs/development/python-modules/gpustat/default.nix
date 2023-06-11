{ lib
, blessed
, buildPythonPackage
, fetchPypi
, mockito
, nvidia-ml-py
, psutil
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "gpustat";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WB6P+FjDLJWjIruPA/HZ3D0Xe07LM93L7Sw3PGf04/E=";
  };

  pythonRelaxDeps = [
    "nvidia-ml-py"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    blessed
    nvidia-ml-py
    psutil
  ];

  nativeCheckInputs = [
    mockito
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gpustat"
  ];

  meta = with lib; {
    description = "A simple command-line utility for querying and monitoring GPU status";
    homepage = "https://github.com/wookayin/gpustat";
    changelog = "https://github.com/wookayin/gpustat/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ billhuang ];
  };
}
