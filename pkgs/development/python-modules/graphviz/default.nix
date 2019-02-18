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
  version = "0.10.1";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "1vqk4xy45c72la56j24z9jmjp5a0aa2k32fybnlbkzqjvvbl72d8";
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
    homepage = https://github.com/xflr6/graphviz;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
