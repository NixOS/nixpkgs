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
  version = "8.0.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "klen";
    repo = "pylama";
    rev = version;
    sha256 = "sha256-Olq/CZ/t1wqACoknAKsvdDKnyLZkxRtHokpu33I3trg=";
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
