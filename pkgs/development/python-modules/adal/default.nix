{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71b0e9b479320f76af4bcd268f7359580ba2e217228e83ff7529f51a9845f393";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
