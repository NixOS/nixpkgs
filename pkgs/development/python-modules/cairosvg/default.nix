{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.1.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e512f555f576b6462b04b585c4ba4c09a43f3a8fec907b60ead21d7d00c550e9";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
