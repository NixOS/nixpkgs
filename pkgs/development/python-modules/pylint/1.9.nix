{ stdenv, lib, buildPythonPackage, fetchPypi, astroid, six, isort,
  mccabe, configparser, backports_functools_lru_cache, singledispatch,
  pytest, pytest-runner, setuptools }:

buildPythonPackage rec {
  pname = "pylint";
  version = "1.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "004kfapkqxqy2s85pmddqv0fabxdxywxrlbi549p0v237pr2v94p";
  };

  checkInputs = [ pytest pytest-runner ];

  propagatedBuildInputs = [ astroid six isort mccabe configparser backports_functools_lru_cache singledispatch setuptools ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    pytest pylint/test -k "not ${lib.concatStringsSep " and not " (
      [ # Broken test
        "test_good_comprehension_checks"
        # requires setuptools
        "test_pkginfo"
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
    homepage = "https://github.com/PyCQA/pylint";
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ ];
  };
}
