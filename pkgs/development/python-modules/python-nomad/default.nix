{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pythonOlder,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "python-nomad";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jrxfive";
    repo = "python-nomad";
    tag = version;
    hash = "sha256-tLS463sYVlOr2iZSgSkd4pHUVCtiIPJ3L8+9omlX4NY=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require nomad agent
  doCheck = false;

  pythonImportsCheck = [ "nomad" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python client library for Hashicorp Nomad";
    homepage = "https://github.com/jrxFive/python-nomad";
    changelog = "https://github.com/jrxFive/python-nomad/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xbreak ];
  };
}
