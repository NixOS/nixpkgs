{ lib
, fetchFromGitHub
, fetchNpmDeps
, buildPythonPackage
, nix-update-script

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
  version = "3.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    rev = "refs/tags/${version}";
    hash = "sha256-E5gM/5MIB65gdyv/I+Kuw8rbjPvtUnbCPXpasaIDzyo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cmd = ["npm", "ci"]' 'cmd = ["true"]' \
      --replace 'f"{self.build_lib}/{name}.mo"' 'f"{name}.mo"'

    sed -i "/addopts/d" setup.cfg
  '';

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-4ZVb+V/oYfflIZdme6hbpoSBFVV7lk5wLfEzzBqZv/Y=";
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

  # needed for npmDeps update
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/arteria/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
