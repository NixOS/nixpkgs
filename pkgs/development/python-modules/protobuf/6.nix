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
  version = "6.33.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l/ZXV+jQmHDeb9lzrt25L4VDVgcjXSCy3+2TQF0AyFs=";
  };

  build-system = [ setuptools ];

  propagatedNativeBuildInputs = [
    protobuf
  ];

  doCheck =
    # https://protobuf.dev/support/cross-version-runtime-guarantee/#backwards
    # The non-python protobuf provides the protoc binary which must not be newer.
    assert lib.versionAtLeast version ("6." + protobuf.version);
    # the pypi source archive does not ship tests
    false;

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
    changelog = "https://github.com/protocolbuffers/protobuf/releases/v${
      builtins.substring 2 (-1) version
    }";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
