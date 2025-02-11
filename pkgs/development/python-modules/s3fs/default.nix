{
  lib,
  aiobotocore,
  aiohttp,
  buildPythonPackage,
  docutils,
  fetchPypi,
  flask,
  flask-cors,
  fsspec,
  moto,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "s3fs";
  version = "2024.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gw86j1lGzKW6KYcdZ5KrHkUo7XYjJ9iu+vyBtzuZ/VY=";
  };

  buildInputs = [ docutils ];

  build-system = [ setuptools ];

  dependencies = [
    aiobotocore
    aiohttp
    fsspec
  ];

  pythonImportsCheck = [ "s3fs" ];

  nativeCheckInputs = [
    flask
    flask-cors
    moto
    pytestCheckHook
  ];

  disabledTests = [
    # require network access
    "test_async_close"
  ];

  meta = {
    description = "Pythonic file interface for S3";
    homepage = "https://github.com/fsspec/s3fs";
    changelog = "https://github.com/fsspec/s3fs/raw/${version}/docs/source/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ teh ];
  };
}
