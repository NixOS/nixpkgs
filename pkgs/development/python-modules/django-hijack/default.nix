{ lib
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
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-hijack";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "hijack.tests.test_app.settings";

  pytestFlagsArray = [
    "--pyargs" "hijack"
    "-W" "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/arteria/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
