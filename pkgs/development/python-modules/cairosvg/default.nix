{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.1.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "70f32d0a7aec46629975d584f43093f59022a47dde403c52b095dcea10cf5b80";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
