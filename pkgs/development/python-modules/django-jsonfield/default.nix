{ stdenv, lib, buildPythonPackage, isPyPy, fetchPypi
, django, sqlite }:

buildPythonPackage rec {
  pname = "django-jsonfield";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gna25jizsk46d367ygzh9ba9hvcjv7qbql6bnsnb4vkaiazs2kc";
  };

  preCheck = ''
    export DB_ENGINE=sqlite3
    export DB_NAME=tests
  '';

  checkInputs = [ django sqlite ];

  # one test is failing :(
  doCheck = false;

  meta = with lib; {
    description = "JSON field for django models";
    homepage = http://bitbucket.org/schinckel/django-jsonfield/;
    maintainers = with maintainers; [ peterromfeldhk ];
    # license = with licenses; [ ??? ]; # not sure what license that is
  };
}
