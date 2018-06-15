{ stdenv, buildPythonPackage, fetchPypi, pytest, glibcLocales, tox, pytestcov, parso }:

buildPythonPackage rec {
  pname = "jedi";
  version = "0.12.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bcr7csx4xil1iwmk03d79jis0bkmgi9k0kir3xa4rmwqsagcwhr";
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
