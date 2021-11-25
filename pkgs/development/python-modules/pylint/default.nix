{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, installShellFiles
, astroid
, isort
, mccabe
, platformdirs
, toml
, pytest-benchmark
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.12.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vvf5b9cwp85mcz7j7zn2pa1m5avmnadi4z50jh3dga9njp8hl97";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    astroid
    isort
    mccabe
    platformdirs
    toml
  ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp -v "elisp/"*.el $out/share/emacs/site-lisp/
    installManPage man/*.1
  '';

  checkInputs = [
    pytest-benchmark
    pytest-xdist
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  # calls executable in one of the tests
  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  pytestFlagsArray = [
    "-n auto"
  ];

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
