{ stdenv, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
, cairocffi, cssselect2, defusedxml, pillow, tinycss2
, pytest, pytestrunner, pytestcov, pytest-flake8, pytest-isort }:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "66f333ef5dc79fdfbd3bbe98adc791b1f854e0461067d202fa7b15de66d517ec";
  };

  patches = [
    # fix isort-check
    (fetchpatch {
      url = https://github.com/Kozea/CairoSVG/commit/b2534b0fc80b9f24a2bff2c938ac5da73ff1e478.patch;
      excludes = [ "test_non_regression/__init__.py" ];
      sha256 = "1bms75dd0fd978yhlr0k565zq45lzxf0vkihryb7gcwnd42bl6yf";
    })
  ];

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytest pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
