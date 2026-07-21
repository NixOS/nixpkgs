{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "datadiff";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fOcN/uqMM/HYjbRrDv/ukFzDa023Ofa7BwqC3omB0ws=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "datadiff" ];

  disabledTests = [
    # slice is an hashable type in recent python versions
    "test_unhashable_type"
  ];

  meta = {
    description = "Library to provide human-readable diffs of Python data structures";
    homepage = "https://sourceforge.net/projects/datadiff/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
