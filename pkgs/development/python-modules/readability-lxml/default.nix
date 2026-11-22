{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  chardet,
  cssselect,
  lxml,
  lxml-html-clean,
  timeout-decorator,
}:

buildPythonPackage rec {
  pname = "readability-lxml";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buriy";
    repo = "python-readability";
    tag = "${version}";
    hash = "sha256-N7f4PYwuTP5MSRw3xXm3lopZfKe6UHkSOJbUMeL5VBU=";
  };

  pythonRelaxDeps = [
    "chardet"
    "cssselect"
    "lxml"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    chardet
    cssselect
    lxml
    lxml-html-clean
  ];

  nativeCheckInputs = [
    pytestCheckHook
    timeout-decorator
  ];

  pythonImportsCheck = [ "readability" ];

  meta = {
    description = "Fast python port of arc90's readability tool";
    homepage = "https://github.com/buriy/python-readability";
    changelog = "https://github.com/buriy/python-readability/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
