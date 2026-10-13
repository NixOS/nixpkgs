{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-gateway-oss-util";
  version = "0.0.13";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_gateway_oss_util";
    inherit (finalAttrs) version;
    hash = "sha256-RlWx2oGOieifxcs0UHhapFVZT5XYJAR3EXPJuJXtMDc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_gateway_oss_util" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud OSS Util Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-gateway-oss-util/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
