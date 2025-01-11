{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "ed25519";
  version = "1.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "warner";
    repo = "python-ed25519";
    tag = version;
    hash = "sha256-AwnhB5UGycQliNndbqd0JlI4vKSehCSy0qHv2EiB+jA=";
  };

  postPatch = ''
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  pythonImportsCheck = [ "ed25519" ];

  meta = with lib; {
    description = "Ed25519 public-key signatures";
    mainProgram = "edsig";
    homepage = "https://github.com/warner/python-ed25519";
    changelog = "https://github.com/warner/python-ed25519/blob/${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ np ];
  };
}
