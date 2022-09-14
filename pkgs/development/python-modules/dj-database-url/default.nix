{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zPPocY913dFHoeIS/KiO7NqnIXWe5I44tIVIHHe8o9w=";
  };

  # Tests access a DB via network
  doCheck = false;

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/kennethreitz/dj-database-url";
    license = licenses.bsd2;
  };
}
