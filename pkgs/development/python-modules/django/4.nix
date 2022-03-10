{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, substituteAll

# patched in
, geos
, gdal
, withGdal ? false

# propagated
, asgiref
, backports-zoneinfo
, sqlparse

# tests
, aiosmtpd
, argon2_cffi
, bcrypt
, docutils
, geoip2
, jinja2
, memcached
, numpy
, pillow
, pylibmc
, pymemcache
, python
, pytz
, pywatchman
, pyyaml
, redis
, selenium
, tblib
, tzdata
}:

buildPythonPackage rec {
  pname = "Django";
  version = "4.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d/8ucFDjMkybZ+KbZwd1RWb1hRQRKprHMxD2DNUmGTA=";
  };

  patches = lib.optional withGdal
    (substituteAll {
      src = ./django_4_set_geos_gdal_lib.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    });

  propagatedBuildInputs = [
    asgiref
    sqlparse
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  # Fails to import asgiref in ~200 tests
  # ModuleNotFoundError: No module named 'asgiref'
  doCheck = false;

  checkInputs = [
    aiosmtpd
    argon2_cffi
    asgiref
    bcrypt
    docutils
    geoip2
    jinja2
    memcached
    numpy
    pillow
    pylibmc
    pymemcache
    pytz
    pywatchman
    pyyaml
    redis
    selenium
    tblib
    tzdata
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests/runtests.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "A high-level Python Web framework that encourages rapid development and clean, pragmatic design.";
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
