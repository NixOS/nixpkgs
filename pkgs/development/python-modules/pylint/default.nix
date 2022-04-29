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
  version = "2.13.5";
  format = "setuptools";

  disabled = pythonOlder "3.6.2";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FB99vmUtoTc0cTjDUSbx80Tesh0vASigSpPktrDYk08=";
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
    # tests miss multiple input files
    # FileNotFoundError: [Errno 2] No such file or directory
    "tests/pyreverse/test_writer.py"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_parallel_execution"
    "test_py3k_jobs_option"
  ];

  meta = with lib; {
    homepage = "https://pylint.pycqa.org/";
    description = "A bug and style checker for Python";
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ ];
  };
}
