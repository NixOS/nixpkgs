{ lib
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zc/+9br103We4ExbYP+vGgyV/A8mXnYvPd+t3jOU5ds=";
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
