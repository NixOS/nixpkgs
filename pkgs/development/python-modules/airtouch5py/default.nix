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
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danzel";
    repo = "airtouch5py";
    tag = version;
    hash = "sha256-3L+cz59wwd1RDmh6ePeatcaaUY8hJYH13knB7he1CFk=";
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

  meta = {
    changelog = "https://github.com/danzel/airtouch5py/releases/tag/${src.tag}";
    description = "Python client for the airtouch 5";
    homepage = "https://github.com/danzel/airtouch5py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
