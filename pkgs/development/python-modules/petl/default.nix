{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "petl";
  version = "1.7.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petl-developers";
    repo = "petl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vR01C6eKEncP9V8o3MAfu3hkr8LfFQDx7Q7NfbfADBM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "petl" ];

  meta = {
    homepage = "https://github.com/petl-developers/petl";
    changelog = "https://github.com/petl-developers/petl/releases/tag/${finalAttrs.src.tag}";
    description = "Python package for extracting, transforming and loading tables of data";
    license = lib.licenses.mit;
    mainProgram = "petl";
    maintainers = with lib.maintainers; [
      alapshin
    ];
  };
})
