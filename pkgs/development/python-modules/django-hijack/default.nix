{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildPythonPackage,
  nix-update-script,

  # build-system
  flit-gettext,
  flit-scm,
  nodejs,
  npmHooks,

  # dependencies
  django,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-hijack";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    rev = "refs/tags/${version}";
    hash = "sha256-uece+tR3Nd32nfKn1gtcWqckN4z5iUP+C0dJxyDPXBA=";
  };

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml

  # missing integrity hashes for yocto-queue, yargs-parser
    cp ${./package-lock.json} package-lock.json
  '';

  npmDeps = fetchNpmDeps {
    inherit src postPatch;
    hash = "sha256-npAFpdqGdttE4facBimS/y2SqwnCvOHJhd60SPR/IaA=";
  };

  build-system = [
    flit-gettext
    flit-scm
    nodejs
    npmHooks.npmConfigHook
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.test_app.settings
  '';

  # needed for npmDeps update
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/django-hijack/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
