{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, substituteAll
, graphviz
, xdg-utils
, makeFontsConf
, freefont_ttf
, mock
, pytest
, pytest-mock
, python
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.19.1";

  disabled = pythonOlder "3.6";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    sha256 = "sha256-pE1lsx/r/BjvW5W2niDx/UeRXxx4kvCyHzAUAG3bdGc=";
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

  checkInputs = [
    mock
    pytest
    pytest-mock
  ];

  checkPhase = ''
    runHook preCheck

    HOME=$TMPDIR ${python.interpreter} run-tests.py

    runHook postCheck
  '';

  # Too many failures due to attempting to connect to com.apple.fonts daemon
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
