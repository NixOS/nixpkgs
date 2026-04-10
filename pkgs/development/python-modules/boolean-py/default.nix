{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "boolean-py";
  version = "5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5iHcdN77ZRGMJnSJLoYkRTY1TeJ3yQ1eF193HKsNqU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "boolean" ];

  meta = {
    description = "Implements boolean algebra in one module";
    homepage = "https://github.com/bastikr/boolean.py";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
