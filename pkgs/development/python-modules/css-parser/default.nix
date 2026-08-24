{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "css-parser";
  version = "1.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-k8f7CM8W1Fu7i5ZLT0iZpOs22b5v/vF/ma0oD0A0s2w=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "css_parser" ];

  meta = {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jethro ];
  };
})
