{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-examples,
  pytestCheckHook,
  pytz,
}:

let
  dirty-equals = buildPythonPackage rec {
    pname = "dirty-equals";
    version = "0.9.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "samuelcolvin";
      repo = "dirty-equals";
      tag = "v${version}";
      hash = "sha256-V+Ef/X4xQNSp2PiiXHHIAZT7v2sjU4vDBd9hNOqiRQw=";
    };

    build-system = [ hatchling ];

    dependencies = [ pytz ];

    doCheck = false;

    passthru.tests.pytest = dirty-equals.overrideAttrs { doCheck = true; };

    nativeCheckInputs = [
      pydantic
      pytest-examples
      pytestCheckHook
    ];

    pythonImportsCheck = [ "dirty_equals" ];

    meta = {
      description = "Module for doing dirty (but extremely useful) things with equals";
      homepage = "https://github.com/samuelcolvin/dirty-equals";
      changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/${src.tag}";
      license = with lib.licenses; [ mit ];
      maintainers = with lib.maintainers; [ fab ];
    };
  };
in
dirty-equals
