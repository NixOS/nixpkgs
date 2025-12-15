{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ansicolor";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "numerodix";
    repo = "ansicolor";
    tag = version;
    hash = "sha256-a/BAU42AfMR8C94GwmrLkvSvolFEjV0LbDypvS9UuOA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ansicolor" ];

  meta = {
    description = "Library to produce ansi color output and colored highlighting and diffing";
    homepage = "https://github.com/numerodix/ansicolor/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
