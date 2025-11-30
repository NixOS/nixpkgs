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

buildPythonPackage rec {
  pname = "plyfile";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dranjan";
    repo = "python-plyfile";
    tag = "v${version}";
    hash = "sha256-bSevEk8ZtJybv6FYsUYKdDJJWyPK7Kstc4NNISdHV2o=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "plyfile" ];

  meta = {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage = "https://github.com/dranjan/python-plyfile";
    maintainers = [ ];
  };
}
