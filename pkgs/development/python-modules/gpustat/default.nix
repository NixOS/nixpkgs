{ buildPythonPackage
, blessed
, fetchPypi
, lib
, mockito
, nvidia-ml-py
, psutil
, pytest-runner
, pythonRelaxDepsHook
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "gpustat";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPwQVASqwRiE9w7S+gbP0hDTzTicyuSpvDhXnHJGDO4=";
  };

  nativeBuildInputs = [
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

  pythonImportsCheck = [ "gpustat" ];

  meta = with lib; {
    description = "A simple command-line utility for querying and monitoring GPU status";
    homepage = "https://github.com/wookayin/gpustat";
    license = licenses.mit;
    maintainers = with maintainers; [ billhuang ];
  };
}
