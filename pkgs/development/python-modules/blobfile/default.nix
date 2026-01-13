{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
  lxml,
  pycryptodomex,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "blobfile";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "christopher-hesse";
    repo = "blobfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/v48rLvlN4lsfWKJvXRNuIO6jdsCgRcSPlJzdOfl3xk=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/christopher-hesse/blobfile/blob/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
