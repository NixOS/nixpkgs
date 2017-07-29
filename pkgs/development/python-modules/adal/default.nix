{ stdenv, buildPythonPackage, fetchPypi
, requests, pyjwt }:

buildPythonPackage rec {
  pname = "adal";
  version = "0.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f32k18ck54adqlgvh6fjhy4yavcyrwy813prjyqppqqq4bn1a09";
  };

  propagatedBuildInputs =  [ requests pyjwt ];

  meta = with stdenv.lib; {
    description = "Library to make it easy for python application to authenticate to Azure Active Directory (AAD) in order to access AAD protected web resources";
    homepage = https://github.com/AzureAD/azure-activedirectory-library-for-python;
    license = licenses.mit;
    maintainers = with maintainers; [ phreedom ];
  };
}
