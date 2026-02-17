{
  lib,
  buildPythonPackage,
  dvc,
  fetchFromGitHub,
  fsspec,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dvc-hdfs";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-hdfs";
    tag = version;
    hash = "sha256-Bo8+El5GC7iyT8SxaJquWFG29BOeilmEMDtTG+RkDGI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
    changelog = "https://github.com/iterative/dvc-hdfs/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
