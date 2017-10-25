{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.11.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6d5973573e76b1fd2ea75f6dcd6445d02d41ff3af5fc61b275b4e323d1dd396";
  };

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
