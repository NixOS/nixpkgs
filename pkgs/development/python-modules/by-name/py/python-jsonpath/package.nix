{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  regex,
}:

buildPythonPackage rec {
  pname = "python-jsonpath";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jg-rp";
    repo = "python-jsonpath";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-eVypnFeqFW2WJfCinWXJulVtxaFpNomK2tZNbmxsxrY=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    strict = [
      # FIXME package iregexp-check
      regex
    ];
  };

  pythonImportsCheck = [ "jsonpath" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.strict;

  meta = {
    changelog = "https://github.com/jg-rp/python-jsonpath/blob/${src.tag}/CHANGELOG.md";
    description = "Flexible JSONPath engine for Python with JSON Pointer and JSON Patch";
    homepage = "https://github.com/jg-rp/python-jsonpath";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
