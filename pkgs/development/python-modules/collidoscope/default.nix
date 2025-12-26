{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  babelfont,
  kurbopy,
  fonttools,
  skia-pathops,
  tqdm,
  uharfbuzz,
  unittestCheckHook,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "collidoscope";
  version = "0.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "collidoscope";
    tag = "v${version}";
    hash = "sha256-1tKbv+i2gbUFJa94xSEj5BrEpZ0+ULgglkYvGMP4NXw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    babelfont
    kurbopy
    fonttools
    skia-pathops
    tqdm
    uharfbuzz
  ];

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python library to detect glyph collisions in fonts";
    homepage = "https://github.com/googlefonts/collidoscope";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
}
