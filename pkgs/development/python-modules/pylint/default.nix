{ stdenv, lib, buildPythonPackage, fetchPypi, pythonOlder, astroid,
  isort, mccabe, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "pylint";
  version = "2.3.1";

  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgzq0da87m7708hrc9h4bc5m4z2p7379i4xyydszasmjns3sgkj";
  };

  nativeBuildInputs = [ pytestrunner ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [ astroid isort mccabe ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Remove broken darwin test
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    pytest pylint/test -k "not ${lib.concatStringsSep " and not " (
      # Broken tests
      [ "member_checks_py37" "iterable_context_py36" ] ++
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
