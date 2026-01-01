{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "gtfs-realtime-bindings";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "gtfs_realtime_bindings";
    inherit version;
    hash = "sha256-hhqdz0xA+aWVIARNhw4zawCJStVji88sSpuZiSNUO0I=";
  };

  build-system = [ setuptools ];

  dependencies = [ protobuf ];
=======
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LoztiQRADMk6t+hSCttpNM+mAe2sxvWT/Cy0RIZiu0c=";
  };

  propagatedBuildInputs = [ protobuf ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Tests are not shipped, only a tarball for Java is present
  doCheck = false;

  pythonImportsCheck = [ "google.transit" ];

<<<<<<< HEAD
  meta = {
    description = "Python bindings generated from the GTFS Realtime protocol buffer spec";
    homepage = "https://github.com/MobilityData/gtfs-realtime-bindings";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python bindings generated from the GTFS Realtime protocol buffer spec";
    homepage = "https://github.com/MobilityData/gtfs-realtime-bindings";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
