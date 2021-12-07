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
  version = "5.5.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "diff_cover";
    inherit version;
    sha256 = "e2d36131c13f571d9f5c4109b9e08b71ed00757eabec0156de74e33f6ef5627f";
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
