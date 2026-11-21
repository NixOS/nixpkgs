{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  bleak,
  meshcore,
  prompt-toolkit,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshcore-cli";
  version = "1.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meshcore-dev";
    repo = "meshcore-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ve9nrQ1xuQdwsrAFZC57CwbunHNfze4pBleEZt7G6Y=";
  };

  build-system = [ hatchling ];

  dependencies = [
    meshcore
    bleak
    prompt-toolkit
    requests
  ];

  pythonImportsCheck = [
    "meshcore_cli"
  ];

  doCheck = false; # no tests

  meta = {
    changelog = "https://github.com/meshcore-dev/meshcore-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Command line interface to MeshCore node";
    homepage = "https://github.com/meshcore-dev/meshcore-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "meshcore-cli";
  };
})
