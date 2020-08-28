{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll
, graphviz
, makeFontsConf
, freefont_ttf
, mock
, pytest
, pytest-mock
, pytestcov
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.14.1";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "02bdiac5x93f2mjw5kpgs6kv81hzg07y0mw1nxvhyg8aignzmh3c";
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

  checkInputs = [ mock pytest pytest-mock pytestcov ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
