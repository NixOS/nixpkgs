{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, CommonMark
, poetry-core
, pygments
, typing-extensions
, pytestCheckHook

# for passthru.tests
, enrich
, httpie
, rich-rst
, textual
}:

buildPythonPackage rec {
  pname = "rich";
  version = "12.6.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g3tXftEoBCJ1pMdLyDBXQvY9haGMQkuY1/UBOtUqrLE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    CommonMark
    pygments
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rich" ];

  passthru.tests = {
    inherit enrich httpie rich-rst textual;
  };

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/Textualize/rich";
    license = licenses.mit;
    maintainers = with maintainers; [ ris jyooru ];
  };
}
