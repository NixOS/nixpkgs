{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, installShellFiles
, astroid
, dill
, isort
, mccabe
, platformdirs
, tomli
, tomlkit
, typing-extensions
, GitPython
, pytest-timeout
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.14.5";
  format = "setuptools";

  disabled = pythonOlder "3.7.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JTFGplqIA6WavwzKOkrm1rHBKNRrplBPvAdEkb/fTlI=";
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
    tomlkit
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
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    typing-extensions
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  disabledTestPaths = [
    "tests/benchmark"
    # tests miss multiple input files
    # FileNotFoundError: [Errno 2] No such file or directory
    "tests/pyreverse/test_writer.py"
  ];

  disabledTests = [
    # AssertionError when self executing and checking output
    # expected output looks like it should match though
    "test_invocation_of_pylint_config"
    "test_generate_rcfile"
    "test_generate_toml_config"
    "test_help_msg"
    "test_output_of_callback_options"
    # Failed: DID NOT WARN. No warnings of type (<class 'UserWarning'>,) were emitted. The list of emitted warnings is: [].
    "test_save_and_load_not_a_linter_stats"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_parallel_execution"
    "test_py3k_jobs_option"
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
