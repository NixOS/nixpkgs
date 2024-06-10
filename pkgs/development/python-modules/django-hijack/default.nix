{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildPythonPackage,
  nix-update-script,

  # build-system
  gettext,
  nodejs,
  npmHooks,
  setuptools-scm,

  # dependencies
  django,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-hijack";
  version = "3.4.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    rev = "refs/tags/${version}";
    hash = "sha256-FXh5OFMTjsKgjEeIS+CiOwyGOs4AisJA+g49rCILDsQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'cmd = ["npm", "ci"]' 'cmd = ["true"]' \
      --replace 'f"{self.build_lib}/{name}.mo"' 'f"{name}.mo"'

    sed -i "/addopts/d" setup.cfg
  '';

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-cZEr/7FW4vCR8gpraT+/rPwYK9Xn22b5WH7lnuK5L4U=";
  };

  nativeBuildInputs = [
    gettext
    nodejs
    npmHooks.npmConfigHook
    setuptools-scm
  ];

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "hijack.tests.test_app.settings";

  pytestFlagsArray = [
    "--pyargs"
    "hijack"
    "-W"
    "ignore::DeprecationWarning"
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
