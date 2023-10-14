{ buildPythonPackage
, fetchPypi
, setuptools
, safetensors
, isPy27
, numpy
, pillow
, requests
, regex
, importlib-metadata
, huggingface-hub
}:

buildPythonPackage rec {
  pname = "diffusers";
  version = "0.21.4";

  disabled = isPy27;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P6w4gzF5Qn8WfGdd2nHue09eYnIARXqNUn5Aza+XJog=";
  };

  propagatedBuildInputs = [
    safetensors
    setuptools
    pillow
    numpy
    requests
    regex
    importlib-metadata
    huggingface-hub
  ];

  doCheck = false;

  meta = {
    description = "Diffusers";
    homepage = "https://github.com/huggingface/diffusers";
  };
}
