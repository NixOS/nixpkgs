{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonAtLeast,
  pythonOlder,
  substituteAll,

  # build
  setuptools,

  # patched in
  geos,
  gdal,
  withGdal ? false,

  # propagates
  asgiref,
  sqlparse,

  # extras
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
  version = "4.2.22";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django";
    repo = "django";
    rev = "refs/tags/${version}";
    hash = "sha256-+kq3GF2Q8uaa+UsZK5uWQIyW9tSjfKAE+yiuDTSVwwA=";
  };

  patches =
    [
      (substituteAll {
        src = ./django_4_set_zoneinfo_dir.patch;
        zoneinfo = tzdata + "/share/zoneinfo";
      })
      # make sure the tests don't remove packages from our pythonpath
      # and disable failing tests
      ./django_4_tests.patch

      # fix filename length limit tests on bcachefs
      # FIXME: remove if ever backported
      (fetchpatch {
        url = "https://github.com/django/django/commit/12f4f95405c7857cbf2f4bf4d0261154aac31676.patch";
        hash = "sha256-+K20/V8sh036Ox9U7CSPgfxue7f28Sdhr3MsB7erVOk=";
      })

      # backport fix for https://code.djangoproject.com/ticket/36056
      # FIXME: remove if ever backported upstream
      (fetchpatch {
        url = "https://github.com/django/django/commit/ec0e784f91b551c654f0962431cc31091926792d.patch";
        includes = [ "django/*" ]; # tests don't apply
        hash = "sha256-8YwdOBNJq6+GNoxzdLyN9HEEIWRXGQk9YbyfPwYVkwU=";
      })
    ]
    ++ lib.optionals withGdal [
      (substituteAll {
        src = ./django_4_set_geos_gdal_lib.patch;
        geos = geos;
        gdal = gdal;
        extension = stdenv.hostPlatform.extensions.sharedLibrary;
      })
    ];

  postPatch =
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "setuptools>=75.8.1" setuptools

      substituteInPlace tests/utils_tests/test_autoreload.py \
        --replace "/usr/bin/python" "${python.interpreter}"
    ''
    + lib.optionalString (pythonAtLeast "3.12" && stdenv.hostPlatform.system == "aarch64-linux") ''
      # Test regression after xz was reverted from 5.6.0 to 5.4.6
      # https://hydra.nixos.org/build/254630990
      substituteInPlace tests/view_tests/tests/test_debug.py \
        --replace-fail "test_files" "dont_test_files"
    '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
    description = "High-level Python Web framework that encourages rapid development and clean, pragmatic design";
    mainProgram = "django-admin";
    homepage = "https://www.djangoproject.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
