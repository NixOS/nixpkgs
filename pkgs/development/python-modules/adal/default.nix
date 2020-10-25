{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8003ba03ef04170195b3eddda8a5ab43649ef2c5f0287023d515affb1ccfcfc3";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = "https://github.com/AzureAD/azure-activedirectory-library-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
