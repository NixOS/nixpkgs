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
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-O5cDP0PWFrxNSdwWqUUkErUKf1Tt9agKJqWIjd4jGqk=";
=======
    hash = "sha256-g7xUB5RfjG4G7J9Upj3KXKSePa+VDit1Zf8pWHfui1o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
