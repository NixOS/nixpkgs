{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, installShellFiles
, astroid
, isort
, mccabe
, toml
, platformdirs
, pytest-benchmark
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.10.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    sha256 = "06xrv79ns4bsk819iqrhjcb36k925yl2zi93l6sv7r228y0y8jl6";
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
