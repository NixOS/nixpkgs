{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycares,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiodns";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "aiodns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a26n8n/nxq/LxgPCQJNFjU4yVSCL7YK1lBkiDdVDo2w=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycares ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [ "aiodns" ];

  meta = {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    changelog = "https://github.com/saghul/aiodns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
