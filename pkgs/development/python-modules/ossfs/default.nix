{
  lib,
  aiooss2,
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  oss2,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ossfs";
  version = "2025.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "ossfs";
    tag = version;
    hash = "sha256-2i7zxLCi4wNCwzWNUbC6lvvdRkK+ksUWds+H6QG6bW4=";
  };

  pythonRelaxDeps = [
    "aiooss2"
    "fsspec"
    "oss2"
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiooss2
    fsspec
    oss2
  ];

  # Most tests require network access
  doCheck = false;

  pythonImportsCheck = [ "ossfs" ];

  meta = with lib; {
    description = "Filesystem for Alibaba Cloud (Aliyun) Object Storage System (OSS)";
    homepage = "https://github.com/fsspec/ossfs";
    changelog = "https://github.com/fsspec/ossfs/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
