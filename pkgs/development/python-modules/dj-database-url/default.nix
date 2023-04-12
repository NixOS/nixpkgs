{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h75ffEyD2bPYzpS4NPls6hSzmG82KarAl6/dkxjXsJg=";
  };

  propagatedBuildInputs = [
    django
  ];

  # Tests access a DB via network
  doCheck = false;

  meta = with lib; {
    description = "Use Database URLs in your Django Application";
    homepage = "https://github.com/kennethreitz/dj-database-url";
    license = licenses.bsd2;
  };
}
