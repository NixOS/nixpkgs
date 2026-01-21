{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pybind11,
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymicro-vad";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pymicro-vad";
    tag = "v${version}";
    hash = "sha256-76/n9p+zulq8Uvqurbi9tNFkBXGchEftwqeFycY3NO0=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymicro_vad" ];

  meta = {
    changelog = "https://github.com/rhasspy/pymicro-vad/releases/tag/${src.tag}";
    description = "Self-contained voice activity detector";
    homepage = "https://github.com/rhasspy/pymicro-vad";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
