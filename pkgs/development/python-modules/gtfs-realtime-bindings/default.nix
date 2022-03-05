{ lib
, buildPythonPackage
, fetchPypi
, protobuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gtfs-realtime-bindings";
  version = "0.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vav7ah6gpkpi44rk202bwpl345rydg6n9zibzx5p7gcsblcwd45";
    extension = "zip";
  };

  propagatedBuildInputs = [
    protobuf
  ];

  # Tests are not shipped, only a tarball for Java is present
  doCheck = false;

  pythonImportsCheck = [ "google.transit" ];

  meta = with lib; {
    description = "Python bindings generated from the GTFS Realtime protocol buffer spec";
    homepage = "https://github.com/andystewart999/TransportNSW";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
