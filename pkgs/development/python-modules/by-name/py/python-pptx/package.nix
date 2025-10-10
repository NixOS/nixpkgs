{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  pillow,
  typing-extensions,
  xlsxwriter,
}:

buildPythonPackage rec {
  pname = "python-pptx";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scanny";
    repo = "python-pptx";
    rev = "v${version}";
    hash = "sha256-KyBttTAtP8sVPjYdrY0XReB+4Xfru8GdyYWuiyNZ67w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
    pillow
    typing-extensions
    xlsxwriter
  ];

  pythonImportsCheck = [
    "pptx"
  ];

  meta = {
    description = "Create Open XML PowerPoint documents in Python";
    homepage = "https://github.com/scanny/python-pptx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
