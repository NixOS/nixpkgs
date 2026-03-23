{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  catalogue,
  hypothesis,
  numpy,
  pydantic,
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "confection";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "confection";
    tag = "release-v${finalAttrs.version}";
    hash = "sha256-C7TAfr7Xq4C+JJI7/XWX1mTf2IvvOQT+q/nnGojhbFU=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "confection" ];

  nativeCheckInputs = [
    catalogue
    hypothesis
    numpy
    pydantic
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release-v(.*)"
      ];
    };
  };

  meta = {
    description = "Library that offers a configuration system";
    homepage = "https://github.com/explosion/confection";
    changelog = "https://github.com/explosion/confection/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
