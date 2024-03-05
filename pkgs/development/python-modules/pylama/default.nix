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
, setuptools
, isort
, pylint
, pytestCheckHook
}:

let pylama = buildPythonPackage rec {
  pname = "pylama";
  version = "8.4.1";

  format = "setuptools";

  src = fetchFromGitHub {
    name = "${pname}-${version}-source";
    owner = "klen";
    repo = "pylama";
    rev = version;
    hash = "sha256-WOGtZ412tX3YH42JCd5HIngunluwtMmQrOSUZp23LPU=";
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
    setuptools
    vulture
  ];

  # escape infinite recursion pylint -> isort -> pylama
  doCheck = false;

  nativeCheckInputs = [
    pylint
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

  passthru.tests = {
    check = pylama.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    description = "Code audit tool for python";
    homepage = "https://github.com/klen/pylama";
    changelog = "https://github.com/klen/pylama/blob/${version}/Changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}; in pylama
