{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.11.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6e799d04d1ade9459ed0f20de47c32f2285438956a677d083d3c98def59fa97";
  };

  postPatch = ''
    substituteInPlace requirements.txt --replace "parso==0.1.0" "parso"
  '';

  checkInputs = [ pytest glibcLocales tox pytestcov ];

  propagatedBuildInputs = [ parso ];

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
