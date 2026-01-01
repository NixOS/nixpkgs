{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-trafficmanager";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-Nb8ZAr8VidYm41lx5aqgCeiECUZytHm3mM0buNTy/fk=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ]
  ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "This is the Microsoft Azure Traffic Manager Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
=======
  meta = with lib; {
    description = "This is the Microsoft Azure Traffic Manager Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
