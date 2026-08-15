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
  version = "3.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "christopher-hesse";
    repo = "blobfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6WECMS05upC+M81EtOlEs1K3NKD/z073PqutA/OCMiE=";
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
    changelog = "https://github.com/christopher-hesse/blobfile/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
