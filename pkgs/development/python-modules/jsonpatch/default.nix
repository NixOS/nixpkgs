{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonpointer,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsonpatch";
  version = "1.33";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-patch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JHBB64LExzHQVoFF2xcsqGlNWX/YeEBa1M/TmfeQLWI=";
  };

  build-system = [ setuptools ];

  dependencies = [ jsonpointer ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonpatch" ];

  enabledTestPaths = [ "tests.py" ];

  meta = {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
