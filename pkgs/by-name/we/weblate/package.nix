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
  postgresqlTestHook,
  postgresql,
  redisTestHook,
  fontconfig,
  nixosTests,

  # runtime inputs
  gitSVN,
  subversion,

  #optional runtime inputs
  git-review,
  tesseract,
  licensee,
  mercurial,
  openssh,
}:

let
  python = python3.override {
    packageOverrides = _final: prev: {
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

  postPatch = ''
    sed -i 's|/bin/true|true|g' weblate/addons/example_pre.py
  '';

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
      manage = "DJANGO_SETTINGS_MODULE='weblate.settings_static' ${python.pythonOnBuildForHost.interpreter} manage.py";
    in
    ''
      mkdir $static
      cat weblate/settings_example.py ${staticSettings} > weblate/settings_static.py
      ${manage} compilemessages
      ${manage} collectstatic --no-input
      ${manage} compress
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

  # Commented entries are not packaged yet
  optional-dependencies = with python.pkgs; {
    alibaba = [
      aliyun-python-sdk-alimt
      aliyun-python-sdk-core
    ];
    amazon = [ boto3 ];
    # antispam = [ python-akismet ];
    # gelf = [ logging-gelf ];
    # gerrit = [ git-review ];
    google = [
      google-cloud-storage
      google-cloud-translate
    ];
    ldap = [ django-auth-ldap ];
    # mercurial = [ mercurial ];
    mysql = [ mysqlclient ];
    openai = [ openai ];
    postgres = [ psycopg ];
    saml = [ python3-saml ];
    # saml2idp = [ djangosaml2idp ];
    # wlhosted = [ wlhosted ];
    wsgi = [ granian ];
    # zxcvbn = [ django-zxcvbn-password-validator ];
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

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      postgresqlTestHook
      postgresql
      redisTestHook
      pytest-cov-stub
      pytest-django
      pytest-xdist
      responses
      respx
      selenium
      standardwebhooks

      gitSVN
      subversion
      gettext
      fontconfig
      borgbackup

      #optional
      git-review
      tesseract
      licensee
      mercurial
      openssh
    ]
    ++ social-auth-core.optional-dependencies.saml
    ++ (lib.concatLists (builtins.attrValues optional-dependencies));

  env = {
    CI_DATABASE = "postgresql";
    DJANGO_SETTINGS_MODULE = "weblate.settings_test";

    # Only needed to make weblate/settings_test.py happy
    CI_DB_PORT = "";
    CI_DB_PASSWORD = "";
    CI_REDIS_HOST = "";
    CI_REDIS_PORT = "";
  };

  # pytest-xdist wants to create an additional database per test group
  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  postgresqlTestSetupPost = ''
    export CI_DB_HOST="$PGHOST"
    export CI_DB_USER="$PGUSER"
    export CI_DB_NAME="$PGDATABASE"

    echo "CACHES[\"avatar\"][\"LOCATION\"] = \"unix://$NIX_BUILD_TOP/run/redis.sock\"" \
      >> weblate/settings_test.py

    ${python.pythonOnBuildForHost.interpreter} manage.py migrate --noinput
    ${python.pythonOnBuildForHost.interpreter} manage.py check
  '';

  disabledTests = [
    # Tries to download things from GitHub
    "test_ocr"
    "test_ocr_backend"
  ];

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
