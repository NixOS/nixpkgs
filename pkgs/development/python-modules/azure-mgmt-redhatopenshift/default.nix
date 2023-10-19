{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-redhatopenshift";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BL2a2L2AwJWvs0V+VpSGaS8//AWMy5m6rdAPDJPbrEo=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  pythonNamespaces = "azure.mgmt";

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.redhatopenshift"
  ];

  meta = with lib; {
    description = "Microsoft Azure Red Hat Openshift Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
