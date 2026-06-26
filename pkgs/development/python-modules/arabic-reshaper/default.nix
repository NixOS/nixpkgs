{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fonttools,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "arabic-reshaper";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mpcabd";
    repo = "python-arabic-reshaper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6i/YcYod341bg9tThZRwvaFRbtU/LxCeirq0yzmMuBI=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    with-fonttools = [ fonttools ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "arabic_reshaper" ];

  meta = {
    description = "Reconstruct Arabic sentences to be used in applications that don't support Arabic";
    homepage = "https://github.com/mpcabd/python-arabic-reshaper";
    changelog = "https://github.com/mpcabd/python-arabic-reshaper/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; mit;
    maintainers = [ ];
  };
})
