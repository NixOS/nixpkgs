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
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdlamotte";
    repo = "meshcore-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wby97e9Xulk2pwNJ9mnvKxWlTsWmH4n3zlTtYi7WS6I=";
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

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/meshcore-dev/meshcore-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Command line interface to MeshCore node";
    homepage = "https://github.com/fdlamotte/meshcore-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haylin ];
    mainProgram = "meshcore-cli";
  };
})
