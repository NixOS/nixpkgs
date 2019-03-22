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
    sha256 = "407845f0c16b6f17547a65864657377446e0b3aa8a629b032bf5053f87f82fe9";
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
