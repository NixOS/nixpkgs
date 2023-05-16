{ lib
<<<<<<< HEAD
, fetchFromGitHub
, fetchNpmDeps
, buildPythonPackage

# build-system
, gettext
, nodejs
, npmHooks
, setuptools-scm

# dependencies
, django

# tests
=======
, fetchPypi
, buildPythonPackage
, django
, django_compat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-hijack";
<<<<<<< HEAD
  version = "3.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    rev = "refs/tags/${version}";
    hash = "sha256-ytQ4xxkBAC3amQbenD8RO5asrbfNAjOspWUY3c2hkig=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cmd = ["npm", "ci"]' 'cmd = ["true"]' \
      --replace 'f"{self.build_lib}/{name}.mo"' 'f"{name}.mo"'

    sed -i "/addopts/d" setup.cfg
  '';

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-FLfMCn2jsLlTTsC+LRMX0dmVCCbNAr2pQUsSQRKgo6E=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    gettext
    nodejs
    npmHooks.npmConfigHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
=======
  version = "3.2.6";

  # the wheel comes with pre-built assets, allowing us to avoid fighting
  # with npm/webpack/gettext to build them ourselves.
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "django_hijack";
    dist = "py3";
    python = "py3";
    hash = "sha256-xFPZ03II1814+bZ5gx7GD/AxYMiLuH6awfSeXEraOHQ=";
  };

  propagatedBuildInputs = [
    django
    django_compat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

<<<<<<< HEAD
  env.DJANGO_SETTINGS_MODULE = "hijack.tests.test_app.settings";

  pytestFlagsArray = [
    "--pyargs" "hijack"
    "-W" "ignore::DeprecationWarning"
=======
  preCheck = ''
    export DJANGO_SETTINGS_MODULE='hijack.tests.test_app.settings'
  '';

  pytestFlagsArray = [
    "--pyargs"
    "hijack"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/arteria/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
