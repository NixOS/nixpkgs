{
  lib,
  buildPythonPackage,
  click,
  eval-type-backport,
  fetchFromGitHub,
  gitUpdater,
  llama-cloud,
  llama-index-core,
  platformdirs,
  hatchling,
  pydantic,
  python-dotenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-cloud-services";
  version = "0.6.94";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "llama_cloud_services";
    tag = "llama-cloud-services-py%40${finalAttrs.version}";
    hash = "sha256-BjwXdv7ekehYGGnKk0ElVlxmGkmtam9RLECgxfM7lYc=";
  };

  sourceRoot = "${finalAttrs.src.name}/py";

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

  # update script sets wrong version
  passthru = {
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "llama-cloud-services-py@";
    };
  };

  meta = {
    description = "Knowledge Agents and Management in the Cloud";
    homepage = "https://github.com/run-llama/llama_cloud_services";
    changelog = "https://github.com/run-llama/llama_cloud_services/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
