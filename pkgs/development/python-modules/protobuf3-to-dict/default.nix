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
    sha256 = "0nibblvj3n20zvq6d73zalbjqjby0w8ji5mim7inhn7vb9dw4hhy";
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
    maintainers = with lib.maintainers; [ nequissimus ];
  };
}
