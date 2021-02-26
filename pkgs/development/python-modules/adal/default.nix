{ lib, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08b94d30676ceb78df31bce9dd0f05f1bc2b6172e44c437cbf5b968a00ac6489";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = "https://github.com/AzureAD/azure-activedirectory-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
