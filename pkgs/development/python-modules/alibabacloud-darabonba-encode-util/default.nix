{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-darabonba-encode-util";
  version = "0.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_darabonba_encode_util";
    inherit (finalAttrs) version;
    hash = "sha256-8pPtX1kz6XBhpR2ArrS9xNOLxn9uCspu2nxdeBSyHEY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_darabonba_encode_util" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Darabonba Encode Util Library for Alibaba Cloud Python SDK";
    homepage = "https://github.com/aliyun/darabonba-crypto-util";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
