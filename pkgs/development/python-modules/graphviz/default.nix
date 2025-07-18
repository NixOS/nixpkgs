{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  graphviz-nox,
  xdg-utils,
  makeFontsConf,
  freefont_ttf,
  setuptools,
  mock,
  pytest-cov-stub,
  pytest-mock,
  pytest7CheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "graphviz";
  version = "0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xflr6";
    repo = "graphviz";
    tag = version;
    hash = "sha256-o6woY+UhbsJtUqIzYGXlC0Pw3su7WG4xlAKSslSADwI=";
  };

  patches = [
    (replaceVars ./paths.patch {
      graphviz = graphviz-nox;
      xdgutils = xdg-utils;
    })
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ freefont_ttf ]; };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytest-cov-stub
    pytest-mock
    pytest7CheckHook
    writableTmpDirAsHomeHook
  ];

  # Too many failures due to attempting to connect to com.apple.fonts daemon
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Simple Python interface for Graphviz";
    homepage = "https://github.com/xflr6/graphviz";
    changelog = "https://github.com/xflr6/graphviz/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
