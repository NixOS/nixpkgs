{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "css-parser";
  version = "1.0.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vx6XKtMzROkyBpZPtM2QjZ3e+fzQwB+pPg1zRnU5Q2M=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "css_parser" ];

  meta = {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jethro ];
  };
}
