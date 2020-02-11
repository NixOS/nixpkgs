{ stdenv, buildPythonPackage, fetchPypi, flake8, six, orderedmultidict }:

buildPythonPackage rec {
  pname = "furl";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v2lakx03d5w8954a39ki44xv5mllnq0a0avhxykv9hrzg0yvjpx";
  };

  checkInputs = [ flake8 ];

  propagatedBuildInputs = [ six orderedmultidict ];

  meta = with stdenv.lib; {
    description = "URL manipulation made simple.";
    homepage = https://github.com/gruns/furl;
    license = licenses.publicDomain;
    maintainers = with maintainers; [ vanzef ];
  };
}
