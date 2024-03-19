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
  pname = "django";
  version = "5.0.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "Django";
    inherit version;
    hash = "sha256-X7N1gNz0omL5JYwfQ3OBmqzKkGQx9QXkaI4386mRld8=";
  };

  patches = [
    (substituteAll {
      src = ./django_5_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
    # prevent tests from messing with our pythonpath
    ./django_5_tests_pythonpath.patch
    # disable test that excpects timezone issues
    ./django_5_disable_failing_tests.patch

    (fetchpatch2 {
      # fix test on 3.12; https://github.com/django/django/pull/17843
      url = "https://github.com/django/django/commit/bc8471f0aac8f0c215b9471b594d159783bac19b.patch";
      hash = "sha256-g1T9b73rmQ0uk1lB+iQy1XwK3Qin3mf5wpRsyYISJaw=";
    })
  ] ++ lib.optionals withGdal [
    (substituteAll {
      src = ./django_5_set_geos_gdal_lib.patch;
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
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
