{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  click,
  diskcache,
  requests,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "girder-client";
  version = "3.2.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "girder";
    repo = "girder";
    rev = "refs/tags/v${version}";
    hash = "sha256-/lRD01ll4FL6cVOmBDECARLXxeMJggeVx4pHWCqcGwI=";
  };

  sourceRoot = "${src.name}/clients/python";

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    click
    diskcache
    requests
    requests-toolbelt
    setuptools # uses `pkg_resources` at runtime
  ];

  pythonImportsCheck = [ "girder_client" ];

  doCheck = false; # no tests

  meta = {
    description = "Client for interacting with the Girder data management platform";
    homepage = "http://girder.readthedocs.io";
    changelog = "https://github.com/girder/girder/releases/tag/v${version}";
    mainProgram = "girder-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
