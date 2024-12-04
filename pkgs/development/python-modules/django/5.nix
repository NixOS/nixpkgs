{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  substituteAll,

  # build-system
  setuptools,

  # patched in
  geos,
  gdal,
  withGdal ? false,

  # dependencies
  asgiref,
  sqlparse,

  # optional-dependencies
  argon2-cffi,
  bcrypt,

  # tests
  aiosmtpd,
  docutils,
  geoip2,
  jinja2,
  numpy,
  pillow,
  pylibmc,
  pymemcache,
  python,
  pywatchman,
  pyyaml,
  pytz,
  redis,
  selenium,
  tblib,
  tzdata,
}:

buildPythonPackage rec {
  pname = "django";
  version = "5.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "django";
    repo = "django";
    rev = "refs/tags/${version}";
    hash = "sha256-rE/aErydql5UjS/IiLpDtA3YOsAa+0uRyo40RsjCGLc=";
  };

  patches =
    [
      (substituteAll {
        src = ./django_5_set_zoneinfo_dir.patch;
        zoneinfo = tzdata + "/share/zoneinfo";
      })
      # prevent tests from messing with our pythonpath
      ./django_5_tests_pythonpath.patch
      # disable test that excpects timezone issues
      ./django_5_disable_failing_tests.patch
    ]
    ++ lib.optionals withGdal [
      (substituteAll {
        src = ./django_5_set_geos_gdal_lib.patch;
        geos = geos;
        gdal = gdal;
        extension = stdenv.hostPlatform.extensions.sharedLibrary;
      })
    ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=61.0.0,<69.3.0" setuptools

    substituteInPlace tests/utils_tests/test_autoreload.py \
      --replace-fail "/usr/bin/python" "${python.interpreter}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    sqlparse
  ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    bcrypt = [ bcrypt ];
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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    # make sure the installed library gets imported
    rm -rf django

    # fails to import github_links from docs/_ext/github_links.py
    rm tests/sphinx/test_github_links.py

    # provide timezone data, works only on linux
    export TZDIR=${tzdata}/${python.sitePackages}/tzdata/zoneinfo

    export PYTHONPATH=$PWD/docs/_ext:$PYTHONPATH
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
    description = "High-level Python Web framework that encourages rapid development and clean, pragmatic design";
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
