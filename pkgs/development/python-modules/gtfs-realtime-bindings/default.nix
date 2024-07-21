{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gtfs-realtime-bindings";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LoztiQRADMk6t+hSCttpNM+mAe2sxvWT/Cy0RIZiu0c=";
  };

  propagatedBuildInputs = [ protobuf ];

  # Tests are not shipped, only a tarball for Java is present
  doCheck = false;

  pythonImportsCheck = [ "google.transit" ];

  meta = with lib; {
    description = "Python bindings generated from the GTFS Realtime protocol buffer spec";
    homepage = "https://github.com/MobilityData/gtfs-realtime-bindings";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
