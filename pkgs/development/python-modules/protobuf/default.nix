{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "5.28.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qll+k4+Du38+SzXwOqRSCNSa6NW8tLwQufyCXgq15CM=";
  };

  build-system = [ setuptools ];

  # the pypi source archive does not ship tests
  doCheck = false;

  pythonImportsCheck = [
    "google.protobuf"
    "google.protobuf.compiler"
    "google.protobuf.internal"
    "google.protobuf.pyext"
    "google.protobuf.testdata"
    "google.protobuf.util"
    "google._upb._message"
  ];

  meta = with lib; {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
