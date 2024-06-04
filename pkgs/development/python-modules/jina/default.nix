{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
   docarray, numpy, grpcio, protobuf, pyyaml
}:
buildPythonPackage rec {
  pname = "jina";
  version = "3.25.1";

  src = fetchFromGitHub {
    inherit pname version;
    owner = "jina-ai";
    repo = "jina";
    rev = "v${version}";
    hash = "sha256-VjxatPynuFdyux5zY3ixAhuafPAROL9GfzGLzfOOnko=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    docarray
    numpy
    grpcio
    protobuf
    pyyaml
  ];

  doCheck = false;

  meta = with lib; {
    description = "Multimodal AI services & pipelines with cloud-native stack";
    homepage = "https://github.com/jina-ai/jina";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
