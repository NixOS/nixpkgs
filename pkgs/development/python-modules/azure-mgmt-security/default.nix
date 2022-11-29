{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-security";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vLp874V/awKi2Yr+sH+YcbFij6M9iGGrE4fnMufbP4Q=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.security"
  ];

  meta = with lib; {
    description = "Microsoft Azure Security Center Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
