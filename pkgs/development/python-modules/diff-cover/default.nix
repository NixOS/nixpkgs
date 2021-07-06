{ lib
, buildPythonPackage
, chardet
, fetchPypi
, inflect
, jinja2
, jinja2_pluralize
, pycodestyle
, pyflakes
, pygments
, pylint
, pytest-mock
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "diff-cover";
  version = "5.4.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "diff_cover";
    inherit version;
    sha256 = "sha256-4iQ9/QcXh/lW8HE6wFZWc6Y57xhAEWu2TQnIUZJNAMs=";
  };

  propagatedBuildInputs = [
    chardet
    inflect
    jinja2
    jinja2_pluralize
    pygments
  ];

  checkInputs = [
    pycodestyle
    pyflakes
    pylint
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    "added_file_pylint_console"
    "file_does_not_exist"
  ];

  pythonImportsCheck = [ "diff_cover" ];

  meta = with lib; {
    description = "Automatically find diff lines that need test coverage";
    homepage = "https://github.com/Bachmann1234/diff-cover";
    license = licenses.asl20;
    maintainers = with maintainers; [ dzabraev ];
  };
}
