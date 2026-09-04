{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydanfossair";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JonasPed";
    repo = "pydanfoss-air";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BAzIUiYz5aI9aKbNBKcjq7jJIw06fzqFwKyTp77NLyE=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydanfossair" ];

  meta = {
    description = "Python interface for Danfoss Air HRV systems";
    homepage = "https://github.com/JonasPed/pydanfoss-air";
    changelog = "https://github.com/JonasPed/pydanfoss-air/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
