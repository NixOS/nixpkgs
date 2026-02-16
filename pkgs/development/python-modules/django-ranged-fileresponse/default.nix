{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pytest,
  pytest-cov,
  pytest-flake8,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-ranged-fileresponse";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wearespindle";
    repo = "django-ranged-fileresponse";
    tag = version;
    hash = "sha256-X27TXH22Lra8LpT6/Tfxt8FJKJZvs4N6938GyrQWJXU=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck

    py.test --cov=ranged_fileresponse --cov-report term-missing --flake8 -vvv

    runHook postCheck
  '';

  nativeCheckInputs = [
    django
    pytest
    pytest-cov
    pytest-flake8
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modified Django FileResponse that adds Content-Range headers";
    homepage = "https://github.com/wearespindle/django-ranged-fileresponse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrtipson ];
  };
}
