{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, graphviz
, xdg-utils
, makeFontsConf
, freefont_ttf
, mock
, pytestCheckHook
, pytest-mock
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.18";

  disabled = pythonOlder "3.6";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "sha256-K98CwG+V+EFwzyawVjRwVhbX2FVfoX7dCAD5PXAWTq8=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit graphviz;
      xdgutils = xdg-utils;
    })
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  checkInputs = [ mock pytestCheckHook pytest-mock ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
