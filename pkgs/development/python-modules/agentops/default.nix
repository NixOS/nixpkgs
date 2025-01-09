{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  pythonOlder,
  gitUpdater,

  # dependencies
  requests,
  psutil,
  packaging,
  termcolor,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "agentops";
  version = "0.3.18";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AgentOps-AI";
    repo = "agentops";
    rev = "refs/tags/${version}";
    hash = "sha256-g3gKvCNGdeGyKCyTEG2Gss+lI5bGqkKftn8T4bB4c0c=";
  };

  dependencies = [
    requests
    psutil
    packaging
    termcolor
    pyyaml
  ];

  pythonRelaxDeps = [
    "psutil"
    "packaging"
  ];

  build-system = [ setuptools ];

  enableParallelBuilding = true;

  doCheck = true;

  pythonImportsCheck = [ "agentops" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "AgentOps helps developers build, evaluate, and monitor AI agents.";
    downloadPage = "https://github.com/AgentOps-AI/agentops/releases/tag/${version}";
    homepage = "https://github.com/AgentOps-AI/agentops";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
