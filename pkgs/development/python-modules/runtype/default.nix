{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:
buildPythonPackage (finalAttrs: {
  name = "runtype";
  version = "0.5.3";
  src = fetchFromGitHub {
    owner = "erezsh";
    repo = "runtype";
    tag = finalAttrs.version;
    hash = "sha256-HGYQsunqewuxmdj9kaRZDZxUOf6hRqBySCq4bdxQ3v4=";
  };
  pyproject = true;
  build-system = [
    poetry-core
  ];
  meta = {
    description = "Utilities for run-time type validation and multiple dispatch";
    homepage = "https://github.com/erezsh/runtype";
    maintainers = with lib.maintainers; [ BrockoliniMorgan ];
    license = lib.licenses.mit;
  };
})
