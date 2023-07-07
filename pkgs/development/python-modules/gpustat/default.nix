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
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "gpustat";
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPwQVASqwRiE9w7S+gbP0hDTzTicyuSpvDhXnHJGDO4=";
  };

  pythonRelaxDeps = [
    "nvidia-ml-py"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
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
