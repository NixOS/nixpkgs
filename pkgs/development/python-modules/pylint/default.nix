{ stdenv, lib, buildPythonPackage, fetchPypi, python, pythonOlder, astroid,
  isort, mccabe, pytest, pytestrunner, pyenchant }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.2.2";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14klyan9lqanyi8qhrbn65k7bgv9p7i7ply662r2lr27wydf57b8";
  };

  checkInputs = [ pytest pytestrunner pyenchant ];

  propagatedBuildInputs = [ astroid isort mccabe ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    pytest pylint/test -k "not ${lib.concatStringsSep " and not " (
      # Broken test
      [ "test_good_comprehension_checks" ] ++
      # Disable broken darwin tests
      lib.optionals stdenv.isDarwin [
        "test_parallel_execution"
        "test_py3k_jobs_option"
      ]
    )}"
  '';

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
