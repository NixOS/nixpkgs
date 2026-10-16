{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  setuptools,
}:

buildPythonPackage rec {
  pname = "gtfs-realtime-bindings";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "gtfs_realtime_bindings";
    inherit version;
    hash = "sha256-v6dCbtU3s3S7/kEKmeeIze8bcAn+HlquLj4Lyf3KfXM=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];

  # Tests are not shipped, only a tarball for Java is present
  doCheck = false;

  pythonImportsCheck = [ "google.transit" ];

  meta = {
    description = "Python bindings generated from the GTFS Realtime protocol buffer spec";
    homepage = "https://github.com/MobilityData/gtfs-realtime-bindings";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
