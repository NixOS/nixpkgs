{ lib
, async-timeout
, buildPythonPackage
, cython
, fetchFromGitHub
, gssapi
, kafka-python
, lz4
, packaging
, python-snappy
, pythonOlder
, zlib
, zstandard
}:

buildPythonPackage rec {
  pname = "aiokafka";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-G9Q77nWUUW+hG/wm9z/S8gea4U1wHZdj7WdK2LsKBos=";
  };

  nativeBuildInputs = [
    cython
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    async-timeout
    kafka-python
    packaging
  ];

  passthru.optional-dependencies = {
    snappy = [
      python-snappy
    ];
    lz4 = [
      lz4
    ];
    zstd = [
      zstandard
    ];
    gssapi = [
      gssapi
    ];
  };

  # Checks require running Kafka server
  doCheck = false;

  pythonImportsCheck = [
    "aiokafka"
  ];

  meta = with lib; {
    description = "Kafka integration with asyncio";
    homepage = "https://aiokafka.readthedocs.org";
    changelog = "https://github.com/aio-libs/aiokafka/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
