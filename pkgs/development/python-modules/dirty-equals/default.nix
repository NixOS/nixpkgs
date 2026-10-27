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
  dirty-equals = buildPythonPackage (finalAttrs: {
    pname = "dirty-equals";
    version = "0.11.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "samuelcolvin";
      repo = "dirty-equals";
      tag = "v${finalAttrs.version}";
      hash = "sha256-JFKWrbMdxhvSBbjQ+S9HPW87CK+5ZZiXHg8Wltlv2YY=";
    };

    postPatch = ''
      # Fix pytest.PytestRemovedIn10Warning: Passing a non-Collection iterable to parametrize is deprecated.
      substituteInPlace tests/test_docs.py \
        --replace-fail "examples," "list(examples),"
    '';

    build-system = [ hatchling ];

    dependencies = [ pytz ];

    doCheck = false;

    passthru.tests.pytest = dirty-equals.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [
      pydantic
      pytest-examples
      pytestCheckHook
    ];

    pythonImportsCheck = [ "dirty_equals" ];

    __structuredAttrs = true;

    meta = {
      description = "Module for doing dirty (but extremely useful) things with equals";
      homepage = "https://github.com/samuelcolvin/dirty-equals";
      changelog = "https://github.com/samuelcolvin/dirty-equals/releases/tag/${finalAttrs.src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ fab ];
    };
  });
in
dirty-equals
