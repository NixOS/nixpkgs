{ stdenv, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "casttube";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g7mksfl341vfsxqvw8h15ci2qwd1rczg41n4fb2hw7y9rikqnzj";
  };

  propagatedBuildInputs = [ requests ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Interact with the Youtube Chromecast api";
    homepage = http://github.com/ur1katz/casttube;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
