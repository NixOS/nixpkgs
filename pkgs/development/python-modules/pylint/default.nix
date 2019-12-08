{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, astroid,
  isort, mccabe, pytestCheckHook, pytestrunner }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.4.4";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3db5468ad013380e987410a8d6956226963aed94ecb5f9d3a28acca6d9ac36cd";
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
