{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s9gz23ky1gm5c1rnqlamary0ikl6xbld1k5g9a1fvvbq7q4ay20";
  };

  doCheck = false;

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = https://github.com/torchbox/django-modelcluster/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
