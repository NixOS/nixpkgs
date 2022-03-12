{ lib
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A0fNyssZoQeO5WzD5tVBO6J7ilkAcQxTu5K12P84Gc0=";
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
