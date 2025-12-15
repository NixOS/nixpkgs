{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycares,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "aiodns";
    tag = "v${version}";
    hash = "sha256-qabXwvJzZ4bq0R2Wkb0terZgjnRRt0/ymLcJkxChR6s=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycares ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [ "aiodns" ];

  meta = {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    changelog = "https://github.com/saghul/aiodns/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
