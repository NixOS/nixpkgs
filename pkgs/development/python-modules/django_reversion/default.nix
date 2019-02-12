{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xjs803r5fxaqpkjbpsb17j8racxa4q1nvjjaj1akkgkgw9dj343";
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
