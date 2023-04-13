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
}:

buildPythonPackage rec {
  pname = "gpustat";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WB6P+FjDLJWjIruPA/HZ3D0Xe07LM93L7Sw3PGf04/E=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "nvidia-ml-py" ];

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
