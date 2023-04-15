{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oss2
, pythonOlder
, setuptools-scm
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "ossfs";
  version = "2023.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-E+SVH4MUTHHhvopEydiPKTmzazHm6mzjEWd2zp4XGvs=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "fsspec"
    "oss2"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    fsspec
    oss2
  ];

  # Most tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "ossfs"
  ];

  meta = with lib; {
    description = "Filesystem for Alibaba Cloud (Aliyun) Object Storage System (OSS)";
    homepage = "https://github.com/fsspec/ossfs";
    changelog = "https://github.com/fsspec/ossfs/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
