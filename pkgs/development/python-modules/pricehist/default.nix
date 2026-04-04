{
  lib,
  fetchFromGitLab,
  buildPythonPackage,
  cssselect,
  curlify,
  lxml,
  poetry-core,
  pytest-mock,
  pytestCheckHook,
  requests,
  responses,
}:
buildPythonPackage (finalAttrs: {
  pname = "pricehist";
  version = "1.4.14";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "chrisberkhout";
    repo = "pricehist";
    tag = finalAttrs.version;
    hash = "sha256-BnyoSYVjs2odnOzSpvgMF860PDkz7tPNnM0s3Fep5G0=";
  };

  pythonRelaxDeps = [ "lxml" ];

  dependencies = [
    requests
    lxml
    cssselect
    curlify
  ];

  build-system = [
    poetry-core
  ];

  nativeCheckInputs = [
    responses
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Command-line tool for fetching and formatting historical price data, with support for multiple data sources and output formats";
    homepage = "https://gitlab.com/chrisberkhout/pricehist";
    license = lib.licenses.mit;
    mainProgram = "pricehist";
  };
})
