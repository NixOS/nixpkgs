{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "dj-database-url";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sjsVBGyzgYDgyVIHvMkP5enb3o7vFgZZB92Fz0ynA2w=";
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
