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
  version = "0.14";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "0kmnad7q3nbq753h73b2ylzc6b7j9v5133cyp9s3skpkshs56fvk";
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
