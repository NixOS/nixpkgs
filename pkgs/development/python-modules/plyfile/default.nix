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
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dranjan";
    repo = "python-plyfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uV5gwRb3LKPF+pPQt/m85mwgVGTaEwusJZVUbmxQrJg=";
  };

  build-system = [ pdm-backend ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "plyfile" ];

  meta = {
    description = "NumPy-based text/binary PLY file reader/writer for Python";
    homepage = "https://github.com/dranjan/python-plyfile";
    maintainers = [ ];
    license = lib.licenses.gpl3Only;
  };
})
