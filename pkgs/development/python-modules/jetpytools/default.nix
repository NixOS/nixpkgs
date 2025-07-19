{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  pytestCheckHook,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "jetpytools";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "jetpytools";
    tag = "v${version}";
    hash = "sha256-U/MtqQRFPYJPUr+f6VKlvjulSsiY2gHBuMg3IcbbEQE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [ "jetpytools" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "RgTools and related functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-pyplugin";
    changelog = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-pyplugin/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
