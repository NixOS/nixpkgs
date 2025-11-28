{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  bitarray,
  crc,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "airtouch5py";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danzel";
    repo = "airtouch5py";
    tag = version;
    hash = "sha256-SJ6AVUbdEy0nvpLe39dH/Wc//fDTf0dIvrvVQDUl5eI=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "bitarray"
    "crc"
  ];

  dependencies = [
    bitarray
    crc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "airtouch5py" ];

  meta = with lib; {
    changelog = "https://github.com/danzel/airtouch5py/releases/tag/${src.tag}";
    description = "Python client for the airtouch 5";
    homepage = "https://github.com/danzel/airtouch5py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
