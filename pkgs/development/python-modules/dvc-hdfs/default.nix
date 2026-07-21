{
  lib,
  buildPythonPackage,
  dvc,
  fetchFromGitHub,
  fsspec,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-hdfs";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-hdfs";
    tag = finalAttrs.version;
    hash = "sha256-Bo8+El5GC7iyT8SxaJquWFG29BOeilmEMDtTG+RkDGI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dvc
    fsspec
  ]
  ++ fsspec.optional-dependencies.arrow;

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [ "dvc_hdfs" ];

  meta = {
    description = "HDFS/WebHDFS plugin for dvc";
    homepage = "https://github.com/iterative/dvc-hdfs";
    changelog = "https://github.com/iterative/dvc-hdfs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
