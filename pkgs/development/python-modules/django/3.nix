{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  geos_3_9,
  gdal,
  asgiref,
  pytz,
  sqlparse,
  tzdata,
  pythonOlder,
  withGdal ? false,
}:

buildPythonPackage rec {
  pname = "django";
  version = "3.2.25";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Django";
    inherit version;
    hash = "sha256-fKOKeGVK7nI3hZTWPlFjbAS44oV09VBd/2MIlbVHJ3c=";
  };

  patches =
    [
      (substituteAll {
        src = ./django_3_set_zoneinfo_dir.patch;
        zoneinfo = tzdata + "/share/zoneinfo";
      })
    ]
    ++ lib.optional withGdal (substituteAll {
      src = ./django_3_set_geos_gdal_lib.patch;
      inherit geos_3_9;
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
    description = "High-level Python Web framework";
    homepage = "https://www.djangoproject.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ georgewhewell ];
    knownVulnerabilities = [
      "Support for Django 3.2 ended on 2024-04-01, see https://www.djangoproject.com/download/#supported-versions."
    ];
  };
}
