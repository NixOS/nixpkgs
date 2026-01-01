{
  lib,
  python3,
  fetchFromGitHub,
  gettext,
  pango,
  harfbuzz,
  librsvg,
  gdk-pixbuf,
  glib,
  gobject-introspection,
<<<<<<< HEAD
  askalono,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  borgbackup,
  writeText,
  nixosTests,
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      django = prev.django_5_2;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "weblate";
<<<<<<< HEAD
  version = "5.15.1";
=======
  version = "5.14.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    tag = "weblate-${version}";
<<<<<<< HEAD
    hash = "sha256-9k6H9/XW7vbXix+zadxHCNl9UJ3yE1ONa/+VRvIGk28=";
=======
    hash = "sha256-DwoJ24yGLJt+bItN/9SW0ruf+Lz3A9JxvD4QjlKaqzw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python.pkgs; [ setuptools ];

  nativeBuildInputs = [ gettext ];

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
      ${python.pythonOnBuildForHost.interpreter} manage.py compilemessages
      ${python.pythonOnBuildForHost.interpreter} manage.py collectstatic --no-input
      ${python.pythonOnBuildForHost.interpreter} manage.py compress
    '';

  pythonRelaxDeps = [
<<<<<<< HEAD
    "celery"
    "certifi"
    "cyrtranslit"
    "django-appconf"
    "urllib3"
=======
    "certifi"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  dependencies =
    with python.pkgs;
    [
      aeidon
      ahocorasick-rs
      altcha
      (toPythonModule (borgbackup.override { python3 = python; }))
      celery
      certifi
      charset-normalizer
<<<<<<< HEAD
      confusable-homoglyphs
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      crispy-bootstrap3
      crispy-bootstrap5
      cryptography
      cssselect
      cython
      cyrtranslit
      dateparser
      diff-match-patch
      disposable-email-domains
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
      djangorestframework-csv
      djangorestframework
      docutils
      drf-spectacular
      drf-standardized-errors
<<<<<<< HEAD
      fedora-messaging
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      pyaskalono
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pycairo
      pygments
      pygobject3
      pyicumessageformat
      pyparsing
      python-dateutil
      qrcode
      rapidfuzz
      redis
      requests
      ruamel-yaml
      sentry-sdk
      siphashc
      social-auth-app-django
      social-auth-core
<<<<<<< HEAD
=======
      standardwebhooks
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      tesserocr
      translate-toolkit
      translation-finder
      unidecode
      user-agents
      weblate-language-data
      weblate-schemas
    ]
    ++ django.optional-dependencies.argon2
    ++ celery.optional-dependencies.redis
    ++ drf-spectacular.optional-dependencies.sidecar
<<<<<<< HEAD
    ++ drf-standardized-errors.optional-dependencies.openapi
    ++ translate-toolkit.optional-dependencies.toml
    ++ urllib3.optional-dependencies.brotli
    ++ urllib3.optional-dependencies.zstd;
=======
    ++ drf-standardized-errors.optional-dependencies.openapi;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    gobject-introspection
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

  meta = {
    description = "Web based translation tool with tight version control integration";
    homepage = "https://weblate.org/";
    changelog = "https://github.com/WeblateOrg/weblate/releases/tag/${src.tag}";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "weblate";
  };
}
