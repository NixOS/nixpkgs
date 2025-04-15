{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "petl";
  version = "1.7.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petl-developers";
    repo = "petl";
    tag = "v${version}";
    hash = "sha256-rew/+GXQq2l1LlsR4yqHJZ/iY21HJ2Lf86KS55L8jsQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "petl"
  ];

  meta = {
    homepage = "https://github.com/petl-developers/petl";
    changelog = "https://github.com/petl-developers/petl/releases/tag/${src.tag}";
    description = "Python package for extracting, transforming and loading tables of data";
    license = lib.licenses.mit;
    mainProgram = "petl";
    maintainers = with lib.maintainers; [
      alapshin
    ];
  };
}
