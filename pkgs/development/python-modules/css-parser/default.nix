{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "css-parser";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebook-utils";
    repo = "css-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RD2ORq/4Sj1Pv53YDiv3XUu0hpJqrIFQpeKkDFR5JBQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "css_parser" ];

  meta = {
    description = "CSS Cascading Style Sheets library for Python";
    homepage = "https://github.com/ebook-utils/css-parser";
    changelog = "https://github.com/ebook-utils/css-parser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ jethro ];
  };
})
