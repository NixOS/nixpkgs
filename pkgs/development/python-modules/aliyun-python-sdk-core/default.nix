{
  lib,
  buildPythonPackage,
  cacert,
  cryptography,
  fetchPypi,
  jmespath,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aliyun-python-sdk-core";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ZRyq1ZfrOdT61s+FEz3/6Sg31TvfYtudjzfatlCLuPk=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    jmespath
  ];

  # All components are stored in a mono repo
  doCheck = false;

  postFixup = ''
    rm $out/${python.sitePackages}/aliyunsdkcore/vendored/requests/packages/certifi/cacert.pem
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/${python.sitePackages}/aliyunsdkcore/vendored/requests/packages/certifi/cacert.pem
  '';

  pythonImportsCheck = [ "aliyunsdkcore" ];

  meta = {
    description = "Core module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-core/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
