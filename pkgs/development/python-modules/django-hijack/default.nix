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
  version = "3.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    rev = "refs/tags/${version}";
    hash = "sha256-D9IyuM+ZsvFZL0nhMt1VQ1DYcKg4CS8FPAgSWLtsXeE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cmd = ["npm", "ci"]' 'cmd = ["true"]' \
      --replace 'f"{self.build_lib}/{name}.mo"' 'f"{name}.mo"'

    sed -i "/addopts/d" setup.cfg
  '';

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-X3bJ6STFq6zGIzXHSd2C67d4kSOVJJR5aBSM3o5T850=";
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
