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
    self = python;
    packageOverrides = _final: prev: {
      django = prev.django_6;
      pygobject = prev.pygobject3;
    };
  };
  python3Packages = python.pkgs;

  GI_TYPELIB_PATH = lib.makeSearchPathOutput "out" "lib/girepository-1.0" [
    pango
    harfbuzz
    librsvg
    gdk-pixbuf
    glib
    gobject-introspection
  ];
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "weblate";
  version = "5.17";
  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    tag = "weblate-${finalAttrs.version}";
    hash = "sha256-+czdS1cICvm8esXxJG9BjzPTJExajxvDoRVH7f+t6lY=";
  };

  postPatch = ''
    sed -i 's|/bin/true|true|g' weblate/addons/example_pre.py
  '';

  build-system = with python3Packages; [ setuptools ];

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
    "requests"
    "pygobject"
    "certifi"
  ];

  dependencies =
    with python3Packages;
    [
      ahocorasick-rs
      altcha
      (toPythonModule (borgbackup.override { python3 = python; }))
      celery
      certifi
      charset-normalizer
      confusable-homoglyphs
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
      django-otp-webauthn
      django-otp
      django-redis
      django
      djangorestframework-csv
      djangorestframework
      docutils
      drf-spectacular
      drf-standardized-errors
      fedora-messaging
      filelock
      gitpython
      hiredis
      html2text
      jsonschema
      lxml
      mistletoe
      nh3
      openpyxl
      packaging
      pillow
      pyaskalono
      pycairo
      pygments
      pygobject
      pyicumessageformat
      pyparsing
      python-dateutil
      qrcode
      rapidfuzz
      redis
      regex
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
      weblate-fonts
      weblate-language-data
      weblate-schemas
    ]
    ++ django.optional-dependencies.argon2
    ++ celery.optional-dependencies.redis
    ++ drf-spectacular.optional-dependencies.sidecar
    ++ drf-standardized-errors.optional-dependencies.openapi
    ++ translate-toolkit.optional-dependencies.chardet
    ++ translate-toolkit.optional-dependencies.fluent
    ++ translate-toolkit.optional-dependencies.ini
    ++ translate-toolkit.optional-dependencies.markdown
    ++ translate-toolkit.optional-dependencies.toml
    ++ translate-toolkit.optional-dependencies.php
    ++ translate-toolkit.optional-dependencies.rc
    ++ translate-toolkit.optional-dependencies.subtitles
    ++ translate-toolkit.optional-dependencies.yaml
    ++ urllib3.optional-dependencies.brotli
    ++ urllib3.optional-dependencies.zstd;

  # Commented entries are not packaged yet
  optional-dependencies = with python3Packages; {
    alibaba = [
      aliyun-python-sdk-alimt
      aliyun-python-sdk-core
    ];
    amazon = [ boto3 ];
    # gelf = [ logging-gelf ];
    # gerrit = [ git-review ];
    google = [
      google-cloud-storage
      google-cloud-translate
    ];
    ldap = [ django-auth-ldap ];
    # mercurial = [ mercurial ];
    openai = [ openai ];
    postgres = [ psycopg ];
    saml = [ python3-saml ];
    # saml2idp = [ djangosaml2idp2 ];
    sphinx = [ sphinx ];
    # wllegal = [ wllegal ];
    wsgi = [ granian ];
    # zxcvbn = [ django-zxcvbn-password-validator ];
  };

  # We don't just use wrapGAppsNoGuiHook because we need to expose GI_TYPELIB_PATH
  env = {
    inherit GI_TYPELIB_PATH;
  };

  makeWrapperArgs = [ "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\"" ];

  nativeCheckInputs =
    with python3Packages;
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
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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

  disabledTestPaths = [
    # Probably network access?
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_component_scopes"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_connection_error"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_invalid_response"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_project_scopes"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_site_wide_scope"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_translation_added"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_announcement"
    "weblate/addons/tests.py::SlackWebhooksAddonsTest::test_bulk_changes"
    "weblate/addons/tests.py::WebhooksAddonTest::test_announcement"
    "weblate/addons/tests.py::WebhooksAddonTest::test_bulk_changes"
    "weblate/addons/tests.py::WebhooksAddonTest::test_category_in_payload"
    "weblate/addons/tests.py::WebhooksAddonTest::test_component_scopes"
    "weblate/addons/tests.py::WebhooksAddonTest::test_connection_error"
    "weblate/addons/tests.py::WebhooksAddonTest::test_invalid_response"
    "weblate/addons/tests.py::WebhooksAddonTest::test_project_scopes"
    "weblate/addons/tests.py::WebhooksAddonTest::test_site_wide_scope"
    "weblate/addons/tests.py::WebhooksAddonTest::test_translation_added"
    "weblate/addons/tests.py::WebhooksAddonTest::test_webhook_signature"
    "weblate/addons/tests.py::WebhooksAddonTest::test_webhook_signature_prefix"

    # Tries to resolve DNS
    "weblate/api/tests.py::ProjectAPITest::test_install_machinery"

    # djangosaml2idp2 is not packaged yet
    "weblate/utils/tests/test_djangosaml2idp.py"

    # Don't understand why
    "weblate/trans/tests/test_alert.py::WebsiteAlertSettingTest::test_website_alerts_enabled"
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
    changelog = "https://github.com/WeblateOrg/weblate/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "weblate";
  };
})
