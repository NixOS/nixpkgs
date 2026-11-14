{
  lib,
  fetchFromGitLab,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  apsw,
  backports-zstd,
  lz4,
  numpy,
  ruamel-yaml,
  safelz4,
  typing-extensions,
  zstandard,

  # nativeCheckInputs
  pytestCheckHook,

  # checkInputs
  declinate,
}:

buildPythonPackage (finalAttrs: {
  pname = "rosbags";
  version = "0.11.9";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "ternaris";
    repo = "rosbags";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPRmlAm44TVAcYTGzKob5GsxjMNJQ4RA9XY65c3Lbeo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    apsw
    lz4
    numpy
    ruamel-yaml
    typing-extensions
    zstandard
  ]
  ++ lib.optional (pythonAtLeast "3.14") safelz4
  ++ lib.optional (pythonOlder "3.14") backports-zstd;

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
    changelog = "https://gitlab.com/ternaris/rosbags/-/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
