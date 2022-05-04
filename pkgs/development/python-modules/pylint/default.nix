{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, installShellFiles
, astroid
, dill
, isort
, mccabe
, platformdirs
, tomli
, typing-extensions
, GitPython
, pytest-benchmark
, pytest-timeout
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.13.8";
  format = "setuptools";

  disabled = pythonOlder "3.6.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-43L6G15zXGgQeWLdJgzNeAX9rVdRbQP/HS3ec4uAg/E=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    astroid
    dill
    isort
    mccabe
    platformdirs
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ] ++ lib.optionals (pythonOlder "3.9") [
    typing-extensions
  ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp -v "elisp/"*.el $out/share/emacs/site-lisp/
    installManPage man/*.1
  '';

  checkInputs = [
    GitPython
    # https://github.com/PyCQA/pylint/blob/main/requirements_test_min.txt
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    typing-extensions
  ];

  dontUseSetuptoolsCheck = true;

  # calls executable in one of the tests
  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$TEMPDIR
  '';

  disabledTestPaths = [
    # Tests fail due to missing input files with error message:
    # FileNotFoundError: [Errno 2] No such file or directory: ...
    "tests/pyreverse/test_writer.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # Fail with error message:
    # 'timeout' not found in `markers` configuration option
    "tests/checkers/unittest_refactoring.py"
    "tests/test_regr.py"
  ];

  meta = with lib; {
    homepage = "https://pylint.pycqa.org/";
    description = "A bug and style checker for Python";
    longDescription = ''
      Pylint is a Python static code analysis tool which looks for programming errors,
      helps enforcing a coding standard, sniffs for code smells and offers simple
      refactoring suggestions.
      Pylint is shipped with following additional commands:
      - pyreverse: an UML diagram generator
      - symilar: an independent similarities checker
      - epylint: Emacs and Flymake compatible Pylint
    '';
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ totoroot ];
  };
}
