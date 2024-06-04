{
  lib,
  buildPythonPackage,
  fetchPypi,
  babelfont,
  kurbopy,
  fonttools,
  skia-pathops,
  tqdm,
  uharfbuzz,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "collidoscope";
  version = "0.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D7MzJ8FZjA/NSXCqCJQ9a02FPPi3t4W0q65wRIDcfSA=";
  };

  propagatedBuildInputs = [
    babelfont
    kurbopy
    fonttools
    skia-pathops
    tqdm
    uharfbuzz
  ];

  doCheck = true;
  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  meta = with lib; {
    description = "Python library to detect glyph collisions in fonts";
    homepage = "https://github.com/googlefonts/collidoscope";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
