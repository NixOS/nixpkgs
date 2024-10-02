{
  lib,
  python3,
  fetchFromGitHub,
  pango,
  harfbuzz,
  librsvg,
  gdk-pixbuf,
  glib,
  borgbackup,
  writeText,
  nixosTests,
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      django = prev.django_5.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ prev.django_5.optional-dependencies.argon2;
      });
      sentry-sdk = prev.sentry-sdk_2;
      djangorestframework = prev.djangorestframework.overridePythonAttrs (old: {
        # https://github.com/encode/django-rest-framework/discussions/9342
        disabledTests = (old.disabledTests or [ ]) ++ [ "test_invalid_inputs" ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "weblate";
  version = "5.7.2";

  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    rev = "refs/tags/weblate-${version}";
    hash = "sha256-cIwCNYXbg7l6z9OAkMAGJ783QI/nCOyrhLPURDcDv+Y=";
  };

  patches = [
    # FIXME This shouldn't be necessary and probably has to do with some dependency mismatch.
    ./cache.lock.patch
  ];

  build-system = with python.pkgs; [ setuptools ];

  # Build static files into a separate output
  postBuild =
    let
      staticSettings = writeText "static_settings.py" ''
        DEBUG = False
        STATIC_ROOT = os.environ["static"]
        COMPRESS_OFFLINE = True
        # So we don't need postgres dependencies
        DATABASES = {}
      '';
    in
    ''
      mkdir $static
      cat weblate/settings_example.py ${staticSettings} > weblate/settings_static.py
      export DJANGO_SETTINGS_MODULE="weblate.settings_static"
      ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input
      ${python.pythonOnBuildForHost.interpreter} manage.py compress
    '';

  dependencies =
    with python.pkgs;
    [
      aeidon
      ahocorasick-rs
      (toPythonModule (borgbackup.override { python3 = python; }))
      celery
      certifi
      charset-normalizer
      django-crispy-bootstrap3
      cryptography
      cssselect
      cython
      cyrtranslit
      diff-match-patch
      django-appconf
      django-celery-beat
      django-compressor
      django-cors-headers
      django-crispy-forms
      django-filter
      django-redis
      django-otp
      django-otp-webauthn
      django
      djangorestframework
      filelock
      fluent-syntax
      gitpython
      hiredis
      html2text
      iniparse
      jsonschema
      lxml
      mistletoe
      nh3
      openpyxl
      packaging
      phply
      pillow
      pycairo
      pygments
      pygobject3
      pyicumessageformat
      pyparsing
      python-dateutil
      python-redis-lock
      qrcode
      rapidfuzz
      redis
      requests
      ruamel-yaml
      sentry-sdk
      siphashc
      social-auth-app-django
      social-auth-core
      tesserocr
      translate-toolkit
      translation-finder
      user-agents
      weblate-language-data
      weblate-schemas
    ]
    ++ python-redis-lock.optional-dependencies.django
    ++ celery.optional-dependencies.redis;

  optional-dependencies = {
    postgres = with python.pkgs; [ psycopg ];
  };

  # We don't just use wrapGAppsNoGuiHook because we need to expose GI_TYPELIB_PATH
  GI_TYPELIB_PATH = lib.makeSearchPathOutput "out" "lib/girepository-1.0" [
    pango
    harfbuzz
    librsvg
    gdk-pixbuf
    glib
  ];
  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" ];

  passthru = {
    inherit python;
    # We need to expose this so weblate can work outside of calling its bin output
    inherit GI_TYPELIB_PATH;
    tests = {
      inherit (nixosTests) weblate;
    };
  };

  meta = with lib; {
    description = "Web based translation tool with tight version control integration";
    homepage = "https://weblate.org/";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen ];
  };
}
