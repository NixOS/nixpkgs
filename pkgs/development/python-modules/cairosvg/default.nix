{ stdenv, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytest, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.5.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fc50d10f0cbef53b3ee376a97a88d81bbd9e2f190f7e63de08431a1a08e9afa";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = "https://cairosvg.org";
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
