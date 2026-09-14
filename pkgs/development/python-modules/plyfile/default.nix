{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  pdm-backend,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "plyfile";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dranjan";
    repo = "python-plyfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eyVw2QSNAa0c3b4NFKLDRH57H+YbuSOw8WdwO1afAeo=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "plyfile" ];

  meta = {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage = "https://github.com/dranjan/python-plyfile";
    changelog = "https://github.com/dranjan/python-plyfile/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
