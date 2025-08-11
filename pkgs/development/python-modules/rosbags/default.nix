{
  lib,
  buildPythonPackage,
  fetchFromGitLab,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  lz4,
  numpy,
  ruamel-yaml,
  typing-extensions,
  zstandard,

  # nativeCheckInputs
  pytestCheckHook,

  # checkInputs
  declinate,
}:

buildPythonPackage rec {
  pname = "rosbags";
  version = "0.10.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ternaris";
    repo = "rosbags";
    tag = "v${version}";
    hash = "sha256-EOuvvC6VTnhZA9M6ZKn0TNjbCm+lXH4/TboDS0hcw1A=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lz4
    numpy
    ruamel-yaml
    typing-extensions
    zstandard
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    declinate
  ];

  pythonImportsCheck = [
    "rosbags"
  ];

  meta = {
    description = "Pure Python library to read, modify, convert, and write rosbag files";
    homepage = "https://gitlab.com/ternaris/rosbags";
    changelog = "https://gitlab.com/ternaris/rosbags/-/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
