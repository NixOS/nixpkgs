{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  lookyloo-models,
  pydantic,
  requests,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylookyloo";
  version = "1.41.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lookyloo";
    repo = "PyLookyloo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xkT6Ih/J64TkaARqIZV6lxnI0JN4TFHhflrYVIVo6oU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    lookyloo-models
    pydantic
    requests
    urllib3
  ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "pylookyloo" ];

  meta = {
    description = "Python CLI and module for Lookyloo";
    homepage = "https://github.com/Lookyloo/PyLookyloo";
    changelog = "https://github.com/Lookyloo/PyLookyloo/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lookyloo";
  };
})
