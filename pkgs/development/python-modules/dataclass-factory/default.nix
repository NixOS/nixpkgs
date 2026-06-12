{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  nose2,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dataclass-factory";
  version = "2.16";
  format = "setuptools";

  # upstream 2.x branch abandoned since 2022; v3 was renamed to adaptix
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "reagento";
    repo = "dataclass-factory";
    rev = version;
    hash = "sha256-0BIWgyAV1hJzFX4xYFqswvQi5F1Ce+V9FKSmNYuJfZM=";
  };

  nativeCheckInputs = [ nose2 ];

  checkInputs = [ typing-extensions ];

  pythonImportsCheck = [ "dataclass_factory" ];

  checkPhase = ''
    runHook preCheck

    nose2 -v tests

    runHook postCheck
  '';

  meta = {
    description = "Modern way to convert python dataclasses or other objects to and from more common types like dicts or json-like structures";
    homepage = "https://github.com/reagento/dataclass-factory";
    changelog = "https://github.com/reagento/dataclass-factory/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
