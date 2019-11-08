{ lib, buildPythonPackage, fetchPypi, setuptools, isPy27, futures
, backports_functools_lru_cache, mock, pytest
}:

buildPythonPackage rec {
  pname = "isort";
  version = "4.3.21"; # Note 4.x is the last version that supports Python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "54da7e92468955c4fceacd0c86bd0ec997b0e1ee80d97f67c35a78b719dccab1";
  };

  propagatedBuildInputs = [
    setuptools
  ] ++ lib.optionals isPy27 [ futures backports_functools_lru_cache ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    # isort excludes paths that contain /build/, so test fixtures don't work
    # with TMPDIR=/build/
    PATH=$out/bin:$PATH TMPDIR=/tmp/ pytest \
      -k 'not requirements_finder and not pipfile_finder and not user_issue_778'
  '';

  meta = with lib; {
    description = "A Python utility / library to sort Python imports";
    homepage = https://github.com/timothycrosley/isort;
    license = licenses.mit;
    maintainers = with maintainers; [ couchemar nand0p ];
  };
}
