{ lib
, buildPythonPackage
, fetchFromGitHub
, fsspec
, oss2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ossfs";
  version = "2021.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5mz1OC+6kDpiLNsMwOp+bdqY2eozMpAekS6h34QiOdo=";
  };

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
