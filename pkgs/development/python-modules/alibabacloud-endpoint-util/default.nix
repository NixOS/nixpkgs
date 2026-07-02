{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-endpoint-util";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_endpoint_util";
    inherit version;
    hash = "sha256-pZPrjd2BaNXcIhbNMxEbFE+RifzW6cog5I81inObv5A=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_endpoint_util" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Endpoint-util module of alibabaCloud Python SDK";
    homepage = "https://pypi.org/project/alibabacloud-endpoint-util/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
