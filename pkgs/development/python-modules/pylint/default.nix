{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, installShellFiles
, astroid
, isort
, mccabe
, toml
, pytest-benchmark
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.8.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a049c5d47b629d9070c3932d13bff482b12119b6a241a93bc460b0be16953c8";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    astroid
    isort
    mccabe
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
