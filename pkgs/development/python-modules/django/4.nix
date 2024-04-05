{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonAtLeast
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
  version = "4.2.11";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Django";
    inherit version;
    hash = "sha256-bm/z2y2N0MmGtO7IVUyOT5GbXB/2KltDkMF6/y7W5cQ=";
  };

  patches = [
    (substituteAll {
      src = ./django_4_set_zoneinfo_dir.patch;
      zoneinfo = tzdata + "/share/zoneinfo";
    })
    # make sure the tests don't remove packages from our pythonpath
    # and disable failing tests
    ./django_4_tests.patch

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
  '' + lib.optionalString (pythonAtLeast "3.12" && stdenv.hostPlatform.system == "aarch64-linux") ''
    # Test regression after xz was reverted from 5.6.0 to 5.4.6
    # https://hydra.nixos.org/build/254630990
    substituteInPlace tests/view_tests/tests/test_debug.py \
      --replace-fail "test_files" "dont_test_files"
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
