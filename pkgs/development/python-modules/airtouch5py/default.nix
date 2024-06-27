{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  poetry-core,
  pythonRelaxDepsHook,

  # dependencies
  bitarray,
  crc,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "airtouch5py";
  version = "0.2.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "danzel";
    repo = "airtouch5py";
    rev = "refs/tags/${version}";
    hash = "sha256-rPx5ZUomuvj/qYGqW52lK0J3OHOR0dWHIkAsnJk2k+Q=";
  };

  build-system = [ poetry-core ];
  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [ "crc" ];

  dependencies = [
    bitarray
    crc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "airtouch5py" ];

  meta = with lib; {
    changelog = "https://github.com/danzel/airtouch5py/releases/tag/${version}";
    description = "Python client for the airtouch 5";
    homepage = "https://github.com/danzel/airtouch5py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
