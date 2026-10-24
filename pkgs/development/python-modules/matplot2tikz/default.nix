{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,

  matplotlib,
  numpy,
  pillow,
  webcolors,
  typing-extensions,

  pytestCheckHook,
  pytest-cov-stub,
  astropy,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "matplot2tikz";
  version = "0.5.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ErwindeGelder";
    repo = "matplot2tikz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pILvB0E61zMT7rrxQqDlz49Dk/nDkb7ytH09A0cExzQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
    numpy
    pillow
    webcolors
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    astropy
    pandas
  ];

  pythonImportsCheck = [ "matplot2tikz" ];

  meta = {
    description = "Convert matplotlib figures into TikZ/PGFPlots";
    homepage = "https://github.com/ErwindeGelder/matplot2tikz";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.haansn08 ];
  };
})
