{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fdqspp08mgsq52gmdxkkwa963j90h5x8ndapn116mk6psax1vdn";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
