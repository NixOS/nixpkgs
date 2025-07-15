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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "devopshq";
    repo = "artifactory";
    tag = version;
    hash = "sha256-oGv7sZWi/e9WWa5W82pJ6d8S2d2e9gaoGZ3P/97IWoI=";
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

  enabledTestPaths = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Python interface library for JFrog Artifactory";
    homepage = "https://devopshq.github.io/artifactory/";
    changelog = "https://github.com/devopshq/artifactory/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ h7x4 ];
  };
}
