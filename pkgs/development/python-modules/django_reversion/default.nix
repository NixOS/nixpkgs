{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed46722389fb2441860d471c7538967dee545bcee891d3d907b04f4baa98f5fa";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = https://github.com/etianen/django-reversion;
    license = licenses.bsd3;
  };

}
