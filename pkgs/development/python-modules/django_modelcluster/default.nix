{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zcn1b0lp9dg6xvz8p8v1hrrgqj71izqalqz2dp1nz5rbj3s34x2";
  };

  disabled = pythonOlder "3.5";

  doCheck = false;

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    description = "Django extension to allow working with 'clusters' of models as a single unit, independently of the database";
    homepage = https://github.com/torchbox/django-modelcluster/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
