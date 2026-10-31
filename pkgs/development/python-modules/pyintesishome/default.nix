{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyintesishome";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jnimmo";
    repo = "pyIntesisHome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ICwwvg7zJVdXP42W4ZtWEnztW3HthHZ0z3OEUoSfjqM=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyintesishome" ];

  meta = {
    description = "Python interface for IntesisHome devices";
    homepage = "https://github.com/jnimmo/pyIntesisHome";
    changelog = "https://github.com/jnimmo/pyIntesisHome/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
