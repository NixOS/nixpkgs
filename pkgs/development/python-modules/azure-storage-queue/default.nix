{ lib
, azure-core
, buildPythonPackage
, cryptography
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-storage-queue";
  version = "12.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-90sni/yKGolR/92StkC4Kad7fNF/qeI1czzVqMW35JY=";
  };

  propagatedBuildInputs = [
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  passthru.optional-dependencies = {
    aio = [
      azure-core
    ] ++ azure-core.optional-dependencies.aio;
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.storage.queue"
  ];

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the queue service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-storage-queue_${version}/sdk/storage/azure-storage-queue/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
