{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a7f1e037c6290c6d7609cab33a9e5e988c2fbec5c51d1c4c649ee3faff37eaf";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
