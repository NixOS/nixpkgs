{
  buildPythonPackage,
  django,
  django-rest-framework,
  fetchFromGitHub,
  lib,
  nix-update-script,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf-generators";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brobin";
    repo = "drf-generators";
    tag = version;
    hash = "sha256-8FAoFd0UYIMkc4YgP16HeGP0XSlCgT7qc/zbn4UVtrk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
  ];

  nativeCheckInputs = [
    django-rest-framework
  ];
  checkPhase = ''
    runHook preCheck

    pushd tests
    python manage.py test
    popd

    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Views, Serializers, and Urls for your Django Rest Framework application";
    homepage = "https://github.com/Brobin/drf-generators";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
    changelog = "https://github.com/Brobin/drf-generators/releases/tag/${src.tag}";
  };
}
