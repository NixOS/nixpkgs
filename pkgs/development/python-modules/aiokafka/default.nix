{
  lib,
  async-timeout,
  buildPythonPackage,
  cramjam,
  cython,
  fetchFromGitHub,
  gssapi,
  packaging,
  setuptools,
  typing-extensions,
  zlib,
}:

buildPythonPackage rec {
  pname = "aiokafka";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiokafka";
    tag = "v${version}";
    hash = "sha256-xmrNhtyFY+3CJhECIVZRMVx0sZbZ00RLiyZzOdPNNIs=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ zlib ];

  dependencies = [
    async-timeout
    packaging
    typing-extensions
  ];

  optional-dependencies = {
    snappy = [ cramjam ];
    lz4 = [ cramjam ];
    zstd = [ cramjam ];
    gssapi = [ gssapi ];
    all = [
      cramjam
      gssapi
    ];
  };

  # Checks require running Kafka server
  doCheck = false;

  pythonImportsCheck = [ "aiokafka" ];

  meta = {
    description = "Kafka integration with asyncio";
    homepage = "https://aiokafka.readthedocs.org";
    changelog = "https://github.com/aio-libs/aiokafka/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
