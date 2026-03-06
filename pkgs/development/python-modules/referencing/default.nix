{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  jsonschema,
  pytestCheckHook,
  rpds-py,
  typing-extensions,
}:

let
  self = buildPythonPackage rec {
    pname = "referencing";
    version = "0.37.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "python-jsonschema";
      repo = "referencing";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-4e06rzvIOyWAgkpzAisc4uUK8pWshDZiQ6qpvJCq3GY=";
    };

    build-system = [
      hatch-vcs
      hatchling
    ];

    dependencies = [
      attrs
      rpds-py
      typing-extensions
    ];

    nativeCheckInputs = [
      jsonschema
      pytestCheckHook
    ];

    # Avoid infinite recursion with jsonschema
    doCheck = false;

    passthru.tests.referencing = self.overridePythonAttrs { doCheck = true; };

    pythonImportsCheck = [ "referencing" ];

    meta = {
      description = "Cross-specification JSON referencing";
      homepage = "https://github.com/python-jsonschema/referencing";
      changelog = "https://github.com/python-jsonschema/referencing/releases/tag/${src.tag}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ fab ];
    };
  };
in
self
