{
  lib,

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

  meta = {
    description = "OCR library trained against simple CAPTCHAs for Latin and Chinese characters";
    homepage = "https://github.com/sml2h3/ddddocr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ simonhollingshead ];
  };
}
