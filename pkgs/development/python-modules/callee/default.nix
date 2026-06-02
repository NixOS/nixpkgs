{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "callee";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Xion";
    repo = "callee";
    tag = finalAttrs.version;
    hash = "sha256-dsXMY3bW/70CmTfCuy5KjxPa+NLCzxzWv5e1aV2NEWE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "callee" ];

  doCheck = false; # missing dependency

  nativeCheckInputs = [
    # taipan missing, unmaintained, not python3.10 compatible
    pytestCheckHook
  ];

  meta = {
    description = "Argument matchers for unittest.mock";
    homepage = "https://github.com/Xion/callee";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
