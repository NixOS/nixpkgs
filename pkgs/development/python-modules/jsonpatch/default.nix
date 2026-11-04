{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jsonpointer,
  pytestCheckHook,
  setuptools,
  simplejson,
}:

buildPythonPackage (finalAttrs: {
  pname = "jsonpatch";
  version = "1.42";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-patch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VMRxdemWx9SeGhAWIe+YVAA6wfnJZ4in6l28428Q6aI=";
  };

  build-system = [ setuptools ];

  dependencies = [ jsonpointer ];

  nativeCheckInputs = [
    pytestCheckHook
    simplejson
  ];

  pythonImportsCheck = [ "jsonpatch" ];

  enabledTestPaths = [ "tests.py" ];

  meta = {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
