{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49e9930f90322dc6a2754dd26144285cfcc1c5bd0c1c39ca95d5602c5054ae32";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  requiredPythonModules = [ django ];

  meta = with stdenv.lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
  };

}
