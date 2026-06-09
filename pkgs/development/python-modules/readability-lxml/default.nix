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
  version = "0.8.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "buriy";
    repo = "python-readability";
    rev = "${version}";
    hash = "sha256-tL0OnvCrbrpBvcy+6RJ+u/BDdra+MnVT51DSAeYxJbc=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "lxml" ];

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

  meta = {
    description = "Fast python port of arc90's readability tool";
    homepage = "https://github.com/buriy/python-readability";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
