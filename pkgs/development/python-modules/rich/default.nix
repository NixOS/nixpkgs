{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, CommonMark
, colorama
, dataclasses
, ipywidgets
, poetry
, pygments
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rich";
  version = "9.13.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0si3rzhg8wfxw4aakkp8sr6nbzfa54rl0w92macd1338q90ha4ly";
  };
  format = "pyproject";

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [
    CommonMark
    colorama
    ipywidgets
    pygments
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.7") dataclasses;

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "rich" ];

  meta = with lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/willmcgugan/rich";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
