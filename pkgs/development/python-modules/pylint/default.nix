{ stdenv, buildPythonPackage, fetchPypi, python, pythonOlder, astroid, isort,
  pytest, pytestrunner,  mccabe, pytest_xdist, pyenchant }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.1.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31142f764d2a7cd41df5196f9933b12b7ee55e73ef12204b648ad7e556c119fb";
  };

  checkInputs = [ pytest pytestrunner pytest_xdist pyenchant ];

  propagatedBuildInputs = [ astroid isort mccabe ];

  postPatch = ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    cat pylint/test/test_self.py
    # Disable broken darwin tests
    pytest pylint/test -k "not test_parallel_execution \
                       and not test_py3k_jobs_option \
                       and not test_good_comprehension_checks"
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.logilab.org/project/pylint;
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ nand0p ];
  };
}
