{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1plsdi44dvsj2sfx79lsrccjfg0ymajcsf5n0mln4cwd4qi5mwpx";
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
