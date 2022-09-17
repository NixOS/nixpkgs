{ lib
, aiohttp
, azure-core
, azure-datalake-store
, azure-identity
, azure-storage-blob
, buildPythonPackage
, fetchFromGitHub
, fsspec
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adlfs";
  version = "2022.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = version;
    hash = "sha256-79HPJip+nocYo/r8LCb9vdYKVuEh0BBrz/eTJF0eGTA=";
  };

  propagatedBuildInputs = [
    aiohttp
    azure-core
    azure-datalake-store
    azure-identity
    azure-storage-blob
    fsspec
  ];

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [
    "adlfs"
  ];

  meta = with lib; {
    description = "Filesystem interface to Azure-Datalake Gen1 and Gen2 Storage";
    homepage = "https://github.com/fsspec/adlfs";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
