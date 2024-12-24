{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  markdown-it-py,
  pygments,
  typing-extensions,

  # optional-dependencies
  ipywidgets,

  # tests
  attrs,
  pytestCheckHook,
  which,

  # for passthru.tests
  enrich,
  httpie,
  rich-rst,
  textual,
}:

buildPythonPackage rec {
  pname = "rich";
  version = "13.9.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich";
    rev = "refs/tags/v${version}";
    hash = "sha256-Zaop9zR+Sz9lMQjQP1ddJSid5jEmf0tQYuTeLuWNGA8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    markdown-it-py
    pygments
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  optional-dependencies = {
    jupyter = [ ipywidgets ];
  };

  nativeCheckInputs = [
    attrs
    pytestCheckHook
    which
  ];

  pythonImportsCheck = [ "rich" ];

  passthru.tests = {
    inherit
      enrich
      httpie
      rich-rst
      textual
      ;
  };

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    changelog = "https://github.com/Textualize/rich/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
