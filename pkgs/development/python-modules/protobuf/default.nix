{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "5.27.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8+ze8ia5r4VgdfKCJ/8skM46WU0JLDm+5VE1c/JeJxQ=";
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
