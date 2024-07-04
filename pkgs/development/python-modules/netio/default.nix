{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
}:

buildPythonPackage rec {
  pname = "netio";
  version = "1.0.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "netioproducts";
    repo = "PyNetio";
    rev = "refs/tags/v${version}";
    hash = "sha256-s/X2WGhQXYsbo+ZPpkVSF/vclaThYYNHu0UY0yCnfPA=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "pyopenssl" ];

  propagatedBuildInputs = [
    requests
    pyopenssl
  ];

  pythonImportsCheck = [ "Netio" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Module for interacting with NETIO devices";
    mainProgram = "Netio";
    homepage = "https://github.com/netioproducts/PyNetio";
    changelog = "https://github.com/netioproducts/PyNetio/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
