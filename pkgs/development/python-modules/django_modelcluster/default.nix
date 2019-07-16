{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "django-modelcluster";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02mrs7aapabapfh7h7n71s8r7zxkmad3yk4rdyfwcf0x36326rsr";
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
