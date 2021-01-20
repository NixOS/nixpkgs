{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, graphviz
, makeFontsConf
, freefont_ttf
, mock
, pytestCheckHook
, pytest-mock
, pytestcov
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.16";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "147vi60mi57z623lhllwwzczzicv2iwj1yrmllj5xx5788i73j6g";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-graphviz-path.patch;
      inherit graphviz;
    })
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  checkInputs = [ mock pytestCheckHook pytest-mock pytestcov ];

  meta = with lib; {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
