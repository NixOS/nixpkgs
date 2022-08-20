{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, substituteAll

# patched in
, fetchpatch
, geos
, gdal
, withGdal ? false

# propagated
, asgiref
, backports-zoneinfo
, sqlparse

# tests
, aiosmtpd
, argon2-cffi
, bcrypt
, docutils
, geoip2
, jinja2
, python-memcached
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
  version = "4.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ay+Kb8fPBczRIU5KLiHfzWojudV1xlc8rMjGeCjb5kI=";
  };

  patches = [
    (fetchpatch {
      # Fix regression in sqlite backend introduced in 4.1.
      # https://github.com/django/django/pull/15925
      url = "https://github.com/django/django/commit/c0beff21239e70cbdcc9597e5be09e505bb8f76c.patch";
      hash = "sha256-QE7QnfYAK74wvK8gDJ15FtQ+BCIWRQKAVvM7v1FzwlE=";
      excludes = [ "docs/releases/4.1.1.txt" ];
    })
    (substituteAll {
      src = ./django_4_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
  ] ++ lib.optionals withGdal [
    (substituteAll {
      src = ./django_4_set_geos_gdal_lib.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

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
    argon2-cffi
    asgiref
    bcrypt
    docutils
    geoip2
    jinja2
    python-memcached
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
