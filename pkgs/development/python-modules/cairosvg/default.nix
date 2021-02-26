{ lib, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytest, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.5.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfa0deea7fa0b9b2f29e41b747a915c249dbca731a4667c2917e47ff96e773e0";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with lib; {
    homepage = "https://cairosvg.org";
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
