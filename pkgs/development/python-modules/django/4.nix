{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch2
, pythonOlder
, substituteAll

# build
, setuptools

# patched in
, geos
, gdal
, withGdal ? false

# propagates
, asgiref
, sqlparse

# extras
, argon2-cffi
, bcrypt

# tests
, aiosmtpd
, docutils
, geoip2
, jinja2
, numpy
, pillow
, pylibmc
, pymemcache
, python
, pywatchman
, pyyaml
, pytz
, redis
, selenium
, tblib
, tzdata
}:

buildPythonPackage rec {
  pname = "Django";
  version = "4.2.10";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sSYO04GxChF1PHNERAjhmGnzJB/EXJhc1VowF3x4nRM=";
  };

  patches = [
    (substituteAll {
      src = ./django_4_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
    # make sure the tests don't remove packages from our pythonpath
    # and disable failing tests
    ./django_4_tests.patch

    (fetchpatch2 {
      # fix test on 3.12; https://github.com/django/django/pull/17843
      url = "https://github.com/django/django/commit/bc8471f0aac8f0c215b9471b594d159783bac19b.patch";
      hash = "sha256-g1T9b73rmQ0uk1lB+iQy1XwK3Qin3mf5wpRsyYISJaw=";
    })
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
    # tests/requirements/py3.txt
    aiosmtpd
    docutils
    geoip2
    jinja2
    numpy
    pillow
    pylibmc
    pymemcache
    pywatchman
    pyyaml
    pytz
    redis
    selenium
    tblib
    tzdata
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    # make sure the installed library gets imported
    rm -rf django

    # provide timezone data, works only on linux
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests
    ${python.interpreter} runtests.py --settings=test_sqlite
    popd

    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://docs.djangoproject.com/en/${lib.versions.majorMinor version}/releases/${version}/";
    description = "A high-level Python Web framework that encourages rapid development and clean, pragmatic design.";
    mainProgram = "django-admin";
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
