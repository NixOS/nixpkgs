{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  opuslib,
  protobuf,
  pytestCheckHook,
  pycrypto,
  setuptools,
}:

buildPythonPackage {
  pname = "pymumble";
  version = "unstable-2024-10-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tjni";
    repo = "pymumble";
    rev = "3241e84e5ce162a20597e4df6a9c443122357fec";
    hash = "sha256-9lfWvfrS+vUFTf9jo4T+VHkm9u/hVjsDszLBQIEZVcQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    opuslib
    protobuf
  ];

  nativeCheckInputs = [
    pycrypto
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymumble_py3"
    "pymumble_py3.constants"
  ];

  meta = {
    description = "Library to create mumble bots";
    homepage = "https://github.com/tjni/pymumble";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thelegy
    ];
  };
}
