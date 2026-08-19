{
  lib,
  aliyun-log-fastpb,
  buildPythonPackage,
  fetchPypi,
  lz4,
  setuptools,
  zstd,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-gateway-sls-util";
  version = "0.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_gateway_sls_util";
    inherit (finalAttrs) version;
    hash = "sha256-KJ8wLg4HRWvl+BG+m5tSZEVXauO5HxJfFYcNM1ohEjQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aliyun-log-fastpb
    lz4
    zstd
  ];

  pythonImportsCheck = [ "alibabacloud_gateway_sls_util" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Gateway SLS Util Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-gateway-sls-util/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
