{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, astroid,
  isort, mccabe, pytestCheckHook, pytestrunner }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.4.2";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7edbae11476c2182708063ac387a8f97c760d9cfe36a5ede0ca996f90cf346c8";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytestCheckHook ];

  propagatedBuildInputs = [ astroid isort mccabe ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  disabledTests = [
    # https://github.com/PyCQA/pylint/issues/3198
    "test_by_module_statement_value"
   ] ++ lib.optionals stdenv.isDarwin [
      "test_parallel_execution"
      "test_py3k_jobs_option"
   ];

  dontUseSetuptoolsCheck = true;

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with lib; {
    homepage = https://github.com/PyCQA/pylint;
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ nand0p ];
  };
}
