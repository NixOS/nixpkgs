{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42bd7fa91af9996d7dfd34e6b027445acbece188d371d63abd19dde4c7ac8fc8";
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
