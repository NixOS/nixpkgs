{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-nanotts";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "py-nanotts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u/CSTo8KzECQTnmHHnNrBCdiL+MEfKczAObwAAvO9zA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = "cd tests";

  pythonImportsCheck = [ "py_nanotts" ];

  meta = {
    description = "Python bindings for NanoTTS (PicoTTS)";
    homepage = "https://github.com/rhasspy/py-nanotts";
    changelog = "https://github.com/rhasspy/py-nanotts/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
