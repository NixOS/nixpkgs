{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.10.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7abb618cac6470ebbd142e59c23daec5e6e063bfcecc8a43a037d2ab57276f4e";
  };

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test test
  '';

  # tox required for tests: https://github.com/davidhalter/jedi/issues/808
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/davidhalter/jedi;
    description = "An autocompletion tool for Python that can be used for text editors";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ garbas ];
  };
}
