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
  version = "1.7.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petl-developers";
    repo = "petl";
    tag = "v${version}";
    hash = "sha256-zTE6s19/xcu7noT+qQXYrJ8ldrSQVi3AunDKoOMB2Qs=";
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
