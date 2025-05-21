{
  lib,
  async-timeout,
  buildPythonPackage,
  cramjam,
  cython,
  fetchFromGitHub,
  gssapi,
  packaging,
  pythonOlder,
  setuptools,
  typing-extensions,
  zlib,
}:

buildPythonPackage rec {
  pname = "aiokafka";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiokafka";
    rev = "refs/tags/v${version}";
    hash = "sha256-CeEPRCsf2SFI5J5FuQlCRRtlOPcCtRiGXJUIQOAbyCc=";
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

  meta = with lib; {
    description = "Kafka integration with asyncio";
    homepage = "https://aiokafka.readthedocs.org";
    changelog = "https://github.com/aio-libs/aiokafka/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
