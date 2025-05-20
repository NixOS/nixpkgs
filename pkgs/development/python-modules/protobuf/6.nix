{
  buildPythonPackage,
  fetchPypi,
  lib,
  python,
  setuptools,
  protobuf,
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "6.31.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MU+rGmoxZGncLdRvmTy76VyGHqaAfakQvs/nR1vCb/4=";
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

  # Tries to explicitly create a namespace package with pkg_resources,
  # which breaks everything with our PYTHONPATH setup.
  postInstall = ''
    rm $out/${python.sitePackages}/google/__init__.py
  '';

  meta = {
    description = "Protocol Buffers are Google's data interchange format";
    homepage = "https://developers.google.com/protocol-buffers/";
    changelog = "https://github.com/protocolbuffers/protobuf/releases/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
