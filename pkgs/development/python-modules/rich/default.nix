{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, markdown-it-py
, poetry-core
, pygments
, typing-extensions
, pytestCheckHook
, setuptools

# for passthru.tests
, enrich
, httpie
, rich-rst
, textual
}:

buildPythonPackage rec {
  pname = "rich";
  version = "13.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ycDmFJa68OOrNqIy/hGKxbjoaIbiniiO4UAPNSyZvDk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    markdown-it-py
    pygments
    setuptools
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rich"
  ];

  passthru.tests = {
    inherit enrich httpie rich-rst textual;
  };

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    changelog = "https://github.com/Textualize/rich/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ris joelkoen ];
  };
}
