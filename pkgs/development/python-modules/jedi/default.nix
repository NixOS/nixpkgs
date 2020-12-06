{ stdenv, buildPythonPackage, fetchFromGitHub, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  # switch back to stable version on the next release.
  # current stable is incompatible with parso
  version = "2020-08-06";

  src = fetchFromGitHub {
    owner = "davidhalter";
    repo = "jedi";
    rev = "216f976fd5cab7a460e5d287e853d11759251e52";
    sha256 = "1kb2ajzigadl95pnwglg8fxz9cvpg9hx30hqqj91jkgrc7djdldj";
    fetchSubmodules = true;
  };

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  propagatedBuildInputs = [ parso ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # tox required for tests: https://github.com/davidhalter/jedi/issues/808
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/davidhalter/jedi";
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
