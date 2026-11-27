{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "devopshq";
    repo = "artifactory";
    tag = version;
    hash = "sha256-bZdCRYnTi0jt1E2s4LropEClDsNHbKb2XAHwuVpgemU=";
  };

  # version.txt in the tagged source holds a placeholder (0.10.0.alpha0)
  postPatch = ''
    echo "${version}" > version.txt
  '';

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

  meta = {
    description = "Python interface library for JFrog Artifactory";
    homepage = "https://devopshq.github.io/artifactory/";
    changelog = "https://github.com/devopshq/artifactory/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ h7x4 ];
  };
}
