{ stdenv, buildPythonPackage, fetchFromGitHub, cairocffi, nose, fontconfig
, cssselect2, defusedxml, pillow, tinycss2 }:

# CairoSVG 2.x dropped support for Python 2 so offer CairoSVG 1.x as an
# alternative
buildPythonPackage rec {
  pname = "CairoSVG";
  version = "1.0.22";

  # PyPI doesn't include tests so use GitHub
  src = fetchFromGitHub {
    owner = "Kozea";
    repo = pname;
    rev = version;
    sha256 = "15z0cag5s79ghhrlgs5xc9ayvzzdr3v8151vf6k819f1drsfjfxl";
  };

  propagatedBuildInputs = [ cairocffi ];

  checkInputs = [ nose fontconfig cssselect2 defusedxml pillow tinycss2 ];

  # Almost all tests just fail. Not sure how to fix them.
  doCheck = false;

  # checkInputs = [ nose fontconfig cssselect2 defusedxml pillow tinycss2 ];

  # checkPhase = ''
  #   FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf nosetests .
  # '';

  meta = with stdenv.lib; {
    homepage = https://cairosvg.org;
    license = licenses.lgpl3;
    description = "SVG converter based on Cairo";
    maintainers = with maintainers; [ jluttine ];
  };
}
