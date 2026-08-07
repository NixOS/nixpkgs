{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  regex,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-jsonpath";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jg-rp";
    repo = "python-jsonpath";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-7kXDGm+pV0daeMEGW/hVb/U69svLFgZfZKklVgV+EJ4=";
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
  ++ finalAttrs.passthru.optional-dependencies.strict;

  meta = {
    changelog = "https://github.com/jg-rp/python-jsonpath/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Flexible JSONPath engine for Python with JSON Pointer and JSON Patch";
    homepage = "https://github.com/jg-rp/python-jsonpath";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
