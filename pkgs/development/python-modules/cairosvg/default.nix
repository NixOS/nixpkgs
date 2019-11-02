{ stdenv, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytest, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.4.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bb7irxbaxxb9ahm3z5wsx1q96mm5gzskc7b6q07h9ikcnb8yrjf";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
