{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cdn";
  version = "13.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

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

  meta = with lib; {
    description = "This is the Microsoft Azure CDN Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cdn_${version}/sdk/cdn/azure-mgmt-cdn/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
