{
  buildPythonPackage,
  cryptography,
  fetchPypi,
  lib,
  protobuf,
  pycryptodome,
  requests,
  protobuf_27,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.4.4";
  pname = "gpapi";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-HA06ie25ny7AXI7AvZgezvowfZ3ExalY8HDkk7betyo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'PROTOC_EXEC = "protoc"' 'PROTOC_EXEC = "${lib.getExe protobuf_27}"'
  '';

  build-system = [ setuptools ];

  buildInputs = [
    protobuf_27
  ];

  dependencies = [
    cryptography
    protobuf
    pycryptodome
    requests
  ];

  preBuild = ''
    export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION="python"
  '';

  # package doesn't contain unit tests
  # scripts in ./test require networking
  doCheck = false;

  pythonImportsCheck = [ "gpapi.googleplay" ];

  meta = {
    homepage = "https://github.com/NoMore201/googleplay-api";
    license = lib.licenses.gpl3Only;
    description = "Google Play Unofficial Python API";
    maintainers = [ ];
  };
}
