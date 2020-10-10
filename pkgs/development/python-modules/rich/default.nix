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
  version = "8.0.0";

  # tests not included in pypi tarball
  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hv27b22x7dbx1i7nzsd8y8fymmvdak2hcx9242jwk4c1a7jr151";
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
