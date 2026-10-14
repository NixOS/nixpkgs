{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "css-parser";
  version = "1.0.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vx6XKtMzROkyBpZPtM2QjZ3e+fzQwB+pPg1zRnU5Q2M=";
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
