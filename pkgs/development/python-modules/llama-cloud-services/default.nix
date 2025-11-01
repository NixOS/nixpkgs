{
  lib,
  buildPythonPackage,
  click,
  deepdiff,
  eval-type-backport,
  fetchFromGitHub,
  llama-cloud,
  llama-index-core,
  platformdirs,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
}:

buildPythonPackage rec {
  pname = "llama-cloud-services";
  version = "0.6.77";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_cloud_services";
    tag = "llama-cloud-services-py%40${version}";
    hash = "sha256-Fl4rmKJ26yeXYjR2qhpusQrRa0sCe6TigWqEyfjA8lQ=";
  };

  sourceRoot = "${src.name}/py";

  pythonRelaxDeps = [ "llama-cloud" ];

  build-system = [ hatchling ];

  dependencies = [
    click
    eval-type-backport
    llama-cloud
    llama-index-core
    platformdirs
    pydantic
    python-dotenv
  ];

  # Missing dependency autoevals
  doCheck = false;

  pythonImportsCheck = [ "llama_cloud_services" ];

  meta = {
    description = "Knowledge Agents and Management in the Cloud";
    homepage = "https://github.com/run-llama/llama_cloud_services";
    changelog = "https://github.com/run-llama/llama_cloud_services/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
