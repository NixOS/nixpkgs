{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-examples,
  pytestCheckHook,
  pythonOlder,
  pytz,
}:

let
  dirty-equals = buildPythonPackage rec {
    pname = "dirty-equals";
    version = "0.9.0";
    pyproject = true;

    disabled = pythonOlder "3.8";

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

    meta = with lib; {
      description = "Module for doing dirty (but extremely useful) things with equals";
      homepage = "https://github.com/samuelcolvin/dirty-equals";
      changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/${src.tag}";
      license = with licenses; [ mit ];
      maintainers = with maintainers; [ fab ];
    };
  };
in
dirty-equals
