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
      celery = prev.celery.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ prev.celery.optional-dependencies.redis;
      });
      python-redis-lock = prev.python-redis-lock.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ prev.python-redis-lock.optional-dependencies.django;
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "weblate";
  version = "5.6.2";

  pyproject = true;

  outputs = [
    "out"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate";
    rev = "weblate-${version}";
    sha256 = "sha256-t/hnigsKjdWCkUd8acNWhYVFmZ7oGn74+12347MkFgM=";
  };

  patches = [
    # FIXME This shouldn't be necessary and probably has to do with some dependency mismatch.
    ./cache.lock.patch
  ];

  # Relax dependency constraints
  # mistletoe: https://github.com/WeblateOrg/weblate/commit/50df46a25dda2b7b39de86d4c65ecd7a685f62e6
  # borgbackup: https://github.com/WeblateOrg/weblate/commit/355c81c977c59948535a98a35a5c05d7e6909703
  # django-crispy-forms: https://github.com/WeblateOrg/weblate/commit/7b341c523ed9b3b41ecfbc5c92dd6156992e4f32
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"mistletoe>=1.3.0,<1.4"' '"mistletoe>=1.3.0,<1.5"' \
      --replace '"borgbackup>=1.2.5,<1.3"' '"borgbackup>=1.2.5,<1.5"' \
      --replace '"django-crispy-forms>=2.1,<2.3"' '"django-crispy-forms>=2.1,<2.4"'
  '';

  build-system = with python.pkgs; [ setuptools ];

  # Build static files into a separate output
  postBuild =
    let
      staticSettings = writeText "static_settings.py" ''
        STATIC_ROOT = os.environ["static"] + "/static"
        COMPRESS_ENABLED = True
        COMPRESS_OFFLINE = True
        COMPRESS_ROOT = os.environ["static"] + "/compressor-cache"
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

  dependencies = with python.pkgs; [
    aeidon
    ahocorasick-rs
    borgbackup
    celery
    certifi
    charset-normalizer
    django-crispy-bootstrap3
    cryptography
    cssselect
    cython
    diff-match-patch
    django-appconf
    django-celery-beat
    django-compressor
    django-cors-headers
    django-crispy-forms
    django-filter
    django-redis
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
    misaka
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
  ];

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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ erictapen ];
  };
}
