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
, tzdata
, pythonOlder
, withGdal ? false
}:

buildPythonPackage rec {
  pname = "django";
  version = "3.2.18";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Django";
    inherit version;
    hash = "sha256-CCCN/okutk//BzynQ7O5UjERBPk55/ba6VT+ctzFM7o=";
  };

  patches = [
    (substituteAll {
      src = ./django_3_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
  ] ++ lib.optional withGdal
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
