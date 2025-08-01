{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  jsonschema,
  pytest-subtests,
  pytestCheckHook,
  pythonOlder,
  rpds-py,
  typing-extensions,
}:

let
  self = buildPythonPackage rec {
    pname = "referencing";
    version = "0.36.2";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "python-jsonschema";
      repo = "referencing";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-VwViFiquacwJlELNDp01DRbtYQHOY4qXS2CjD7YmS6g=";
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
      pytest-subtests
      pytestCheckHook
    ];

    # Avoid infinite recursion with jsonschema
    doCheck = false;

    passthru.tests.referencing = self.overridePythonAttrs { doCheck = true; };

    pythonImportsCheck = [ "referencing" ];

    meta = with lib; {
      description = "Cross-specification JSON referencing";
      homepage = "https://github.com/python-jsonschema/referencing";
      changelog = "https://github.com/python-jsonschema/referencing/releases/tag/${src.tag}";
      license = licenses.mit;
      maintainers = with maintainers; [ fab ];
    };
  };
in
self
