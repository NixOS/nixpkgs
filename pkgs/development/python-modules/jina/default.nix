{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "jina";
  version = "3.25.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lb7nEZu0Wd7hUnkfuZdPbuy0vJ0kONZ1S1z1ZccF5gE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  meta = with lib; {
    description = "Multimodal AI services & pipelines with cloud-native stack";
    homepage = "https://github.com/jina-ai/jina";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
