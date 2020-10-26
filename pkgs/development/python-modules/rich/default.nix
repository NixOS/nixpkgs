{ stdenv
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
  version = "9.1.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "18iha0fs8vm0j11k39yxj26h8qxrp27ijhx6h1yyizbygmr5b5nk";
  };
  format = "pyproject";

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [
    CommonMark
    colorama
    ipywidgets
    pygments
    typing-extensions
  ] ++ stdenv.lib.optional (pythonOlder "3.7") dataclasses;

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "rich" ];

  meta = with stdenv.lib; {
    description = "Render rich text, tables, progress bars, syntax highlighting, markdown and more to the terminal";
    homepage = "https://github.com/willmcgugan/rich";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
