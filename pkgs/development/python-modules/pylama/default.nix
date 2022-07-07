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
, isort
, pylint
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylama";
  version = "8.3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    name = "${pname}-${version}-source";
    owner = "klen";
    repo = "pylama";
    rev = version;
    hash = "sha256-g6Lq5NaieUI/alxqoVFfL5VaCHwB/jLcp02/N1W69yE=";
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
    # avoid infinite recursion pylint -> isort -> pylama
    (pylint.override {
      isort = isort.overridePythonAttrs (old: {
        doCheck = false;
      });
    })
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  disabledTests = [
    "test_quotes" # FIXME package pylama-quotes
    "test_radon" # FIXME package radon
  ];

  pythonImportsCheck = [
    "pylama.main"
  ];

  meta = with lib; {
    description = "Code audit tool for python";
    homepage = "https://github.com/klen/pylama";
    changelog = "https://github.com/klen/pylama/blob/${version}/Changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
