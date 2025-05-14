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
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pymicro-vad";
    tag = version;
    hash = "sha256-yKy/oD6nl2qZW64+aAHZRAEFextCXT6RpMfPThB8DXE=";
  };

  build-system = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymicro_vad" ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/pymicro-vad/releases/tag/${version}";
    description = "Self-contained voice activity detector";
    homepage = "https://github.com/rhasspy/pymicro-vad";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
