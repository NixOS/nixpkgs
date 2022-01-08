{ lib
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6991f16e5d3a972912db3d56e3a714d10b07becd566ab87f85f2e9b671981339";
  };

  # tests assume the availability of a mysql/postgresql database
  doCheck = false;

  propagatedBuildInputs = [ django ];

  pythonImportsCheck = [ "reversion" ];

  meta = with lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = "https://github.com/etianen/django-reversion";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
