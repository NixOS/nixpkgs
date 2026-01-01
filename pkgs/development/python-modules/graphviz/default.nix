{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    (fetchpatch {
      # python314 compat; https://github.com/xflr6/graphviz/pull/238
      url = "https://github.com/xflr6/graphviz/commit/7e0fae6d28792a628a25cadd4ec1582c7351a7a3.patch";
      hash = "sha256-cZhNsQFi30uFpPXbEJHQ9eol7g6pdv6w8kp1GxLTBD4=";
    })
  ];

  # Fontconfig error: Cannot load default config file
  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
=======
  ];

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ freefont_ttf ]; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
