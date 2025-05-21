{
  lib,
  stdenv,

  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  onnxruntime,
  pillow,
  opencv-python-headless,
}:

buildPythonPackage rec {
  pname = "ddddocr";
  version = "1.5.6";
  pyproject = true;

  # The maintainers do not track versions as tags or releases in GitHub, only
  # in PyPI - so it's preferable to use fetchPypi.
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KDmpQL+r4C4yhO8/nSoDcpKqn2QfNVtDqbcL7Onhtz0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    onnxruntime
    pillow
    opencv-python-headless
  ];

  # https://github.com/microsoft/onnxruntime/issues/10038 - in the restricted
  # build environment, ARM64 cannot import ddddocr (but it can normally).
  pythonImportsCheck = lib.optionals (!stdenv.isAarch64) [ "ddddocr" ];

  meta = {
    description = "OCR library trained against simple CAPTCHAs for Latin and Chinese characters";
    homepage = "https://github.com/sml2h3/ddddocr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ simonhollingshead ];
  };
}
