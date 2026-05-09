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
  version = "5.15.1";

  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    tag = "weblate-${version}";
    hash = "sha256-9k6H9/XW7vbXix+zadxHCNl9UJ3yE1ONa/+VRvIGk28=";
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
    "cyrtranslit"
    "django-appconf"
    "urllib3"
    "dateparser"
    "requests"
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
    knownVulnerabilities = [
      "CVE-2026-24126: 6.6 Medium https://github.com/NixOS/nixpkgs/issues/510510"
      "CVE-2026-27457: 4.3 Medium https://github.com/NixOS/nixpkgs/issues/494757"
      "CVE-2026-33212: 3.1 Low https://github.com/NixOS/nixpkgs/issues/510512"
      "CVE-2026-33214: 4.3 Medium https://github.com/NixOS/nixpkgs/issues/510520"
      "CVE-2026-33220: 6.8 Medium https://github.com/NixOS/nixpkgs/issues/510519"
      "CVE-2026-33435: 8.1 High https://github.com/NixOS/nixpkgs/issues/510516"
      "CVE-2026-33440: 5.0 Medium https://github.com/NixOS/nixpkgs/issues/510517"
      "CVE-2026-34242: 7.7 High https://github.com/NixOS/nixpkgs/issues/510511"
      "CVE-2026-34244: 5.0 Medium https://github.com/NixOS/nixpkgs/issues/510515"
      "CVE-2026-34393: 8.8 High https://github.com/NixOS/nixpkgs/issues/510513"
      "CVE-2026-39845: 4.1 Medium https://github.com/NixOS/nixpkgs/issues/510509"
      "CVE-2026-40256: 5.0 Medium https://github.com/NixOS/nixpkgs/issues/510518"
      "CVE-2026-41519: 4.2 Medium https://github.com/NixOS/nixpkgs/issues/518006"
      "CVE-2026-44263: 4.3 Medium https://github.com/NixOS/nixpkgs/issues/518008"
      "CVE-2026-44264: 4.3 Medium https://github.com/NixOS/nixpkgs/issues/518015"
    ];
  };
}
