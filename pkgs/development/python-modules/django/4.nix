{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, substituteAll

# build
, setuptools

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
, glibcLocales
, jinja2
, numpy
, pillow
, pylibmc
, pymemcache
, python
, pywatchman
, pyyaml
, redis
, selenium
, tblib
, tzdata
}:

buildPythonPackage rec {
  pname = "Django";
  version = "4.1.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RPcUuBxfGQ2dLdrQGlMv5QL6AcTLj68dCB9CZO0V3Ng=";
  };

  patches = [
    (substituteAll {
      src = ./django_4_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
    # make sure the tests don't remove packages from our pythonpath
    ./django_4_pythonpath.patch
  ] ++ lib.optionals withGdal [
    (substituteAll {
      src = ./django_4_set_geos_gdal_lib.patch;
      geos = geos;
      gdal = gdal;
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    })
  ];

  postPatch = ''
    substituteInPlace tests/utils_tests/test_autoreload.py \
      --replace "/usr/bin/python" "${python.interpreter}"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asgiref
    sqlparse
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  passthru.optional-dependencies = {
    argon2 = [
      argon2-cffi
    ];
    bcrypt = [
      bcrypt
    ];
  };

  nativeCheckInputs = [
    aiosmtpd
    asgiref
    docutils
    geoip2
    glibcLocales
    jinja2
    numpy
    pillow
    pylibmc
    pymemcache
    pywatchman
    pyyaml
    redis
    selenium
    tblib
    tzdata
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    # make sure the installed library gets imported
    rm -rf django

    export LC_TIME=UTC
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests
    ${python.interpreter} runtests.py --settings=test_sqlite
    popd

    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://docs.djangoproject.com/en/${lib.versions.majorMinor version}/releases/${version}/";
    description = "A high-level Python Web framework that encourages rapid development and clean, pragmatic design.";
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
