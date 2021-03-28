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
  version = "9.10.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m1rswg16r4pxv7504nk7lpyxrwf16xw4w55rs3jisryx14ccic6";
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
