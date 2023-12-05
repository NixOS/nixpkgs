{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cdn";
  version = "13.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yJ8jTeT4Gu23YSHl5GZ0+zdlC3s+GIxS4ir8z/HBkA4=";
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
