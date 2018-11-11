{ stdenv, lib, buildPythonPackage, fetchPypi, python, astroid, six, isort,
  mccabe, configparser, backports_functools_lru_cache, singledispatch,
  pytest, pytestrunner, pyenchant }:

buildPythonPackage rec {
  pname = "pylint";
  version = "1.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09bc539f85706f2cca720a7ddf28f5c6cf8185708d6cb5bbf7a90a32c3b3b0aa";
  };

  checkInputs = [ pytest pytestrunner pyenchant ];

  propagatedBuildInputs = [ astroid six isort mccabe configparser backports_functools_lru_cache singledispatch ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    pytest pylint/test -k "not ${lib.concatStringsSep " and not " (
      [ # Broken test
        "test_good_comprehension_checks"
        # See PyCQA/pylint#2535
        "test_libmodule" ] ++
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
