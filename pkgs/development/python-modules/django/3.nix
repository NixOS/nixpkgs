{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, geos39
, gdal
, asgiref
, pytz
, sqlparse
, pythonOlder
, withGdal ? false
}:

buildPythonPackage rec {
  pname = "django";
  version = "3.2.14";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Django";
    inherit version;
    sha256 = "sha256-Z3GCuotbKFpOBy86wXzu5q/xtc53/Rc8xbai09wCL88=";
  };

  patches = lib.optional withGdal
    (substituteAll {
      src = ./django_3_set_geos_gdal_lib.patch;
      inherit geos39;
      inherit gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    });

  propagatedBuildInputs = [
    asgiref
    pytz
    sqlparse
  ];

  # too complicated to setup
  doCheck = false;

  pythonImportsCheck = [ "django" ];

  meta = with lib; {
    description = "A high-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell ];
  };
}
