{ stdenv, buildPythonPackage, fetchPypi, isPy3k, fetchpatch
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

  patches = [
    # Fix tests. Remove with the next release
    (fetchpatch {
      url = https://github.com/Kozea/CairoSVG/commit/1f403ad229f0e2782d6427a79f0fbeb6b76148b6.patch;
      sha256 = "1dxpj5zh8wmx9f8pj11hrixd5jlaqq5xlcdnbl462bh29zj18l26";
    })
  ];

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  checkInputs = [ pytestrunner pytestcov pytest-flake8 pytest-isort ];

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
  };
}
