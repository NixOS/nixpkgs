{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, git
, eradicate
, mccabe
, mypy
, pycodestyle
, pydocstyle
, pyflakes
, vulture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylama";
  version = "8.3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    name = "${pname}-${version}-source";
    owner = "klen";
    repo = "pylama";
    rev = version;
    hash = "sha256-KU/G+2Fm4G/dUuNhhk8xM0Y8+7YOUUgREONM8CQGugw=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      git = "${lib.getBin git}/bin/git";
    })
  ];

  propagatedBuildInputs = [
    eradicate
    mccabe
    mypy
    pycodestyle
    pydocstyle
    pyflakes
    vulture
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_pylint" # infinite recursion
    "test_quotes" # FIXME package pylama-quotes
    "test_radon" # FIXME package radon
    "test_sort"
  ];

  pythonImportsCheck = [
    "pylama.main"
  ];

  meta = with lib; {
    description = "Code audit tool for python";
    homepage = "https://github.com/klen/pylama";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
