{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt, dateutil }:

buildPythonPackage rec {
  pname = "adal";
  version = "0.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd3ecb2dfb2de9393320d0ed4e6115ed07a6984a28e18adf46499b91d3c3a494";
  };

  propagatedBuildInputs =  [ requests pyjwt dateutil ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
