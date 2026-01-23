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
  askalono,
  borgbackup,
  writeText,
  nixosTests,
}:

let
  python = python3.override {
    packageOverrides = final: prev: {
      django = prev.django_5;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "weblate";
  version = "5.15.2";

  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    tag = "weblate-${version}";
    hash = "sha256-qNv3aaPyQ/bOrPbK7u9vtq8R1MFqXLJzvLUZfVgjMK0=";
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
    "certifi"
    "urllib3"
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
      confusable-homoglyphs
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
      fedora-messaging
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
      pyaskalono
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
      tesserocr
      translate-toolkit
      translation-finder
      unidecode
      urllib3
      user-agents
      weblate-language-data
      weblate-schemas
    ]
    ++ django.optional-dependencies.argon2
    ++ celery.optional-dependencies.redis
    ++ drf-spectacular.optional-dependencies.sidecar
    ++ drf-standardized-errors.optional-dependencies.openapi
    ++ translate-toolkit.optional-dependencies.toml
    ++ urllib3.optional-dependencies.brotli
    ++ urllib3.optional-dependencies.zstd;

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
