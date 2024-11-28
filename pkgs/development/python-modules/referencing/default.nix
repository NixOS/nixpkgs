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
}:

let
  self = buildPythonPackage rec {
    pname = "referencing";
    version = "0.35.1";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "python-jsonschema";
      repo = "referencing";
      rev = "refs/tags/v${version}";
      fetchSubmodules = true;
      hash = "sha256-Ix0cpdOs7CtersdfW9daF/+BEJaV/na1WRTlYywUJV8=";
    };

    build-system = [
      hatch-vcs
      hatchling
    ];

    dependencies = [
      attrs
      rpds-py
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
      changelog = "https://github.com/python-jsonschema/referencing/releases/tag/v${version}";
      license = licenses.mit;
      maintainers = with maintainers; [ fab ];
    };
  };
in
self
