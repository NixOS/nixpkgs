{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cdn";
  version = "13.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RmMwTzG2Zy3sMgx857qXFcK5nn2LaEs3XwtO/9qQIQw=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure CDN Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cdn_${version}/sdk/cdn/azure-mgmt-cdn/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
