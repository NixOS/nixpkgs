{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, astroid,
  isort, mccabe, pytestCheckHook, pytest-benchmark, pytestrunner, toml }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.5.3";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7dd78437f2d8d019717dbf287772d0b2dbdfd13fc016aa7faa08d67bccc46adc";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytestCheckHook pytest-benchmark ];

  propagatedBuildInputs = [ astroid isort mccabe toml ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  disabledTests = [
    # https://github.com/PyCQA/pylint/issues/3198
    "test_by_module_statement_value"
    # has issues with local directories
    "test_version"
   ] ++ lib.optionals stdenv.isDarwin [
      "test_parallel_execution"
      "test_py3k_jobs_option"
   ];

  # calls executable in one of the tests
  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  dontUseSetuptoolsCheck = true;

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with lib; {
    homepage = "https://github.com/PyCQA/pylint";
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ nand0p ];
  };
}
