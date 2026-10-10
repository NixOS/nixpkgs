{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymicro-vad";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pymicro-vad";
    tag = "v${version}";
    hash = "sha256-CGtyb4RQj5+c6P/JqbW2y6KHYj+UbraRVqeWxeYX0Z8=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymicro_vad" ];

  meta = {
    changelog = "https://github.com/rhasspy/pymicro-vad/releases/tag/${src.tag}";
    description = "Self-contained voice activity detector";
    homepage = "https://github.com/rhasspy/pymicro-vad";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
