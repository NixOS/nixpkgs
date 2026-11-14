{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  django,
  djangorestframework,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-enumfield";
  # No tag for 3.1 but a release commit https://github.com/5monkeys/django-enumfield/commit/5d7c958e657b57d21e6f549090dccf71c2e21393
  # Not worth setting -unstable suffix
  version = "3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "5monkeys";
    repo = "django-enumfield";
    rev = "5d7c958e657b57d21e6f549090dccf71c2e21393";
    hash = "sha256-75TgfsyJTlOseOc/q2hEecM/U5k9wVVDCHJY5A9915o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
  ];

  pythonImportsCheck = [
    "django_enumfield"
  ];

  nativeCheckInputs = [
    djangorestframework
  ];

  checkPhase = ''
    runHook preCheck
    python run_tests.py
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Custom Django field for using enums with model fields";
    homepage = "https://github.com/5monkeys/django-enumfield";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
