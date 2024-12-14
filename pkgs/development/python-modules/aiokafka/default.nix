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
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiokafka";
    rev = "refs/tags/v${version}";
    hash = "sha256-OU/Kept3TvMfGvVCjSthfZnfTX6/T0Fy3PS/ynrV3Cg=";
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
