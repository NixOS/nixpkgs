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
  version = "6.4.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "diff_cover";
    inherit version;
    sha256 = "b1d782c1ce53ad4b2c5545f8b7aa799eb61a0b12a62b376a18e2313c6f2d77f1";
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
