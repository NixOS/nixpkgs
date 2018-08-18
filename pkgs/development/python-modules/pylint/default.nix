{ stdenv, buildPythonPackage, fetchPypi, python, pythonOlder, astroid, isort,
  pytest, pytestrunner,  mccabe, pytest_xdist, pyenchant }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.0.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c90a24bee8fae22ac98061c896e61f45c5b73c2e0511a4bf53f99ba56e90434";
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
