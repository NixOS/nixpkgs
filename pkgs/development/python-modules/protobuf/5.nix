{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "5.29.6";
  pyproject = true;
  # nixpkgs-update: no auto update

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2p7mpUJLazD9XkXF6mY671QMqV+a2Z0eiH6BnN+bhyM=";
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
