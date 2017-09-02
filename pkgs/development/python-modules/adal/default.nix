{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "0.4.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c5bbf4d8a17d535e6e857b28a41cedddc2767fc57424c15d484fa779bb97325";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
