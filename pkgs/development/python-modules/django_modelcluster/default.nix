{ lib
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e541a46a0a899ef4778a4708be22e71cac3efacc09a6ff44bc065c5c9194c054";
  };

  disabled = pythonOlder "3.5";

  doCheck = false;

  propagatedBuildInputs = [ pytz six ];

  meta = with lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
