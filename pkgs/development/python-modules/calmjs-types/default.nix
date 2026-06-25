{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "calmjs-types";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "calmjs.types";
    inherit (finalAttrs) version;
    hash = "sha256-EGWYv9mx3RPqs9dnB5t3Bu3hiujL2y/XxyMP7JkjjAQ=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "calmjs.types" ];

  meta = {
    description = "Types for the calmjs framework";
    homepage = "https://github.com/calmjs/calmjs.types";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
