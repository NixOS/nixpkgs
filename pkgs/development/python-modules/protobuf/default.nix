{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "5.29.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Tx3815l7Me+PU+yCeB/0NKKL9x2RAt3eFNB2rc/HjJk=";
  };

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [
    protobuf
  ];

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

  meta = {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    changelog = "https://github.com/protocolbuffers/protobuf/releases/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
