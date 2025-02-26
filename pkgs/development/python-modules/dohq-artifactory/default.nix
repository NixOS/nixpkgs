{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  setuptools,
  requests,
  python-dateutil,
  pyjwt,
  pytestCheckHook,
  responses,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "dohq-artifactory";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "devopshq";
    repo = "artifactory";
    tag = version;
    hash = "sha256-g6FozwSieurnXS76+yu/lBeL4yIWXdoyl9cUyUpMJx0=";
  };

  # https://github.com/devopshq/artifactory/issues/470
  disabled = pythonAtLeast "3.13";

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    requests
    python-dateutil
    pyjwt
  ];

  pythonImportsCheck = [ "artifactory" ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python interface library for JFrog Artifactory";
    homepage = "https://devopshq.github.io/artifactory/";
    changelog = "https://github.com/devopshq/artifactory/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
  };
}
