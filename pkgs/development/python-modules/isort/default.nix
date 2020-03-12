{ lib, buildPythonPackage, fetchPypi, setuptools, isPy27, futures
, backports_functools_lru_cache, mock, pytest
}:

let
  skipTests = [ "test_requirements_finder" "test_pipfile_finder" ] ++ lib.optional isPy27 "test_standard_library_deprecates_user_issue_778";
  testOpts = lib.concatMapStringsSep " " (t: "--deselect test_isort.py::${t}") skipTests;
in buildPythonPackage rec {
  pname = "isort";
  version = "4.3.20"; # Note 4.x is the last version that supports Python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "c40744b6bc5162bbb39c1257fe298b7a393861d50978b565f3ccd9cb9de0182a";
  };

  propagatedBuildInputs = [
    setuptools
  ] ++ lib.optionals isPy27 [ futures backports_functools_lru_cache ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    # isort excludes paths that contain /build/, so test fixtures don't work
    # with TMPDIR=/build/
    PATH=$out/bin:$PATH TMPDIR=/tmp/ pytest ${testOpts}

    # Confirm that the produced executable script is wrapped correctly and runs
    # OK, by launching it in a subshell without PYTHONPATH
    (
      unset PYTHONPATH
      echo "Testing that `isort --version-number` returns OK..."
      $out/bin/isort --version-number
    )
  '';

  meta = with lib; {
    description = "A Python utility / library to sort Python imports";
    homepage = https://github.com/timothycrosley/isort;
    license = licenses.mit;
    maintainers = with maintainers; [ couchemar nand0p ];
  };
}
