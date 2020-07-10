{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "5.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a42cf9b93d1161a10bf59919f7ee52d996a523a4134b2a136f6fe1eba7a2fa";
  };

  disabled = pythonOlder "3.5";

  doCheck = false;

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = "https://github.com/torchbox/django-modelcluster/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
