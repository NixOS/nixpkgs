{ lib
, aiooss2
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oss2
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ossfs";
  version = "2023.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xYxoEU4+XyiEZThLEyRVHNFg7Bc6jrYEEtq8o+4PtnY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  pythonRelaxDeps = [
    "aiooss2"
    "fsspec"
    "oss2"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiooss2
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
