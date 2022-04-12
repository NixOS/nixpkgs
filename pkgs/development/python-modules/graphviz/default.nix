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
  version = "0.19.2";

  disabled = pythonOlder "3.7";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    hash = "sha256-LxXi0Es6ZJT/nSS6SjGg/3stmR25T4R7TZC34mbT+EA=";
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
    changelog = "https://github.com/xflr6/graphviz/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };

}
