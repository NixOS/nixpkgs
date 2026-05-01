{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  lxml,
  pycryptodomex,
  urllib3,
}:

buildPythonPackage rec {
  pname = "blobfile";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "christopher-hesse";
    repo = "blobfile";
    tag = "v${version}";
    hash = "sha256-aTHEJ1P+v9IWXPg9LN+KG1TlEVJh0qTl8J41iWpoPWk=";
  };

  propagatedBuildInputs = [
    pycryptodomex
    filelock
    urllib3
    lxml
  ];

  # Tests require a running Docker instance
  doCheck = false;

  pythonImportsCheck = [ "blobfile" ];

  meta = {
    description = "Read Google Cloud Storage, Azure Blobs, and local paths with the same interface";
    homepage = "https://github.com/christopher-hesse/blobfile";
    changelog = "https://github.com/christopher-hesse/blobfile/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
