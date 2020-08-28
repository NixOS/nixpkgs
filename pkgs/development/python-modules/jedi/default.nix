{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "86ed7d9b750603e4ba582ea8edc678657fb4007894a12bcf6f4bb97892f31d20";
  };

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  propagatedBuildInputs = [ parso ];

  # remove next bump, >=0.17.2, already fixed in master
  prePatch = ''
    substituteInPlace requirements.txt \
      --replace "parso>=0.7.0,<0.8.0" "parso"
  '';

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
