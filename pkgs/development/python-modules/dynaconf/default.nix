{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  ansible-core,
}:

buildPythonPackage rec {
  pname = "dynaconf";
  version = "3.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dynaconf";
    repo = "dynaconf";
    tag = version;
    hash = "sha256-xY5fCkhZP3nY2QnTtauLhbiEhUgANeavoxYsm5DsIFc=";
  };

  build-system = [ setuptools ];

  dependencies = [ ansible-core ];

  pythonImportsCheck = [ "dynaconf" ];

  meta = {
    description = "Dynamic configurator for Python Project";
    homepage = "https://github.com/dynaconf/dynaconf";
    changelog = "https://github.com/dynaconf/dynaconf/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
