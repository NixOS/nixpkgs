{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  six,
}:

buildPythonPackage rec {
  pname = "protobuf3-to-dict";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HkLCW1r7WGjjqbGWKBEHfkksF1V/nGbw/kDYITddK1o=";
  };

  doCheck = false;

  pythonImportsCheck = [ "protobuf_to_dict" ];

  propagatedBuildInputs = [
    protobuf
    six
  ];

  meta = {
    description = "Teeny Python library for creating Python dicts from protocol buffers and the reverse";
    homepage = "https://github.com/kaporzhu/protobuf-to-dict";
    license = lib.licenses.publicDomain;
  };
}
