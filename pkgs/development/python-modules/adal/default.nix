{ lib, buildPythonPackage, fetchPypi
, requests, pyjwt, python-dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d74f45b81317454d96e982fd1c50e6fb5c99ac2223728aea8764433a39f566f1";
  };

  propagatedBuildInputs =  [ requests pyjwt python-dateutil ];

  meta = with lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = "https://github.com/AzureAD/azure-activedirectory-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
