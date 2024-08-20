{
  lib,
  adal,
  azure-common,
  buildPythonPackage,
  fetchPypi,
  msal,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "azure-datalake-store";
  version = "0.0.53";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BbbeYu4/KgpuaUHmkzt5K4AMPn9v/OL8MkvBmHV1c5M=";
  };

  propagatedBuildInputs = [
    adal
    azure-common
    msal
    requests
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project is the Python filesystem library for Azure Data Lake Store";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
