{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.2.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "93c5b3204478c4e20c4baeb33807db5311b4420c21db2f21034a6deda998cb14";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
