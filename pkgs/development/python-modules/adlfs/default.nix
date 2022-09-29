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
  version = "2022.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = pname;
    rev = version;
    hash = "sha256-7gL0B4rOMsMYYqElY9hSZeAICWA+mO5N+Xe357DWgu8=";
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
