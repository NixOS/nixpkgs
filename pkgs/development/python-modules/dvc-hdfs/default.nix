{ lib
, buildPythonPackage
, dvc
, fetchFromGitHub
, fsspec
, pythonOlder
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dvc-hdfs";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-hdfs";
    rev = "refs/tags/${version}";
    hash = "sha256-Bo8+El5GC7iyT8SxaJquWFG29BOeilmEMDtTG+RkDGI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc
    fsspec
  ] ++ fsspec.optional-dependencies.arrow;

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvc_hdfs"
  ];

  meta = with lib; {
    description = "HDFS/WebHDFS plugin for dvc";
    homepage = "https://github.com/iterative/dvc-hdfs";
    changelog = "https://github.com/iterative/dvc-hdfs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
