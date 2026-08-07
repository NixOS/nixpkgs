{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  mock,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-dns";
  version = "0.36.1";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_dns";
    inherit version;
    hash = "sha256-Uf4riBDfgTadviwIe6KUSypgIZBeMQSOTe6cmP8fEkk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  preCheck = ''
    # don#t shadow python imports
    rm -r google
  '';

  disabledTests = [
    # Test requires credentials
    "test_quota"
  ];

  pythonImportsCheck = [ "google.cloud.dns" ];

  meta = {
    description = "Google Cloud DNS API client library";
    homepage = "https://cloud.google.com/dns";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-dns-v${version}/packages/google-cloud-dns/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
