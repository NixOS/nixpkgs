{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, substituteAll
, graphviz
, xdg-utils
, makeFontsConf
, freefont_ttf
, setuptools
, mock
, pytest
, pytest-mock
, python
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.20.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  # patch does not apply to PyPI tarball due to different line endings
  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    rev = version;
    hash = "sha256-plhWG9mE9DoTMg7mWCvFLAgtBx01LAgJ0gQ/mqBU3yc=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit graphviz;
      xdgutils = xdg-utils;
    })
    # https://github.com/xflr6/graphviz/issues/209
    (fetchpatch {
      name = "fix-tests-with-python312.patch";
      url = "https://github.com/xflr6/graphviz/commit/5ce9fc5de4f2284baa27d7a8d68ab0885d032868.patch";
      hash = "sha256-jREPACSc4aoHY3G+39e8Axqajw4eeKkAeVu2s40v1nI=";
    })
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
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
