{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  aiofile,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-randomly,
  faker,
}:

buildPythonPackage rec {
  pname = "nonbloat-db";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PerchunPak";
    repo = "nonbloat-db";
    tag = "v${version}";
    hash = "sha256-x6QFOZ+RYdophuRXMKE4RNi1xDnsa3naUMDbn1vG7hM=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiofile
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-randomly
    faker
  ];

  pythonImportsCheck = [
    "nbdb"
    "nbdb.storage"
  ];

  disabledTests = [
    # flaky
    "test_write_in_background"
  ];

  meta = {
    description = "Simple key-value database for my small projects";
    homepage = "https://github.com/PerchunPak/nonbloat-db";
    changelog = "https://github.com/PerchunPak/nonbloat-db/blob/v${version}/CHANGES.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ perchun ];
  };
}
