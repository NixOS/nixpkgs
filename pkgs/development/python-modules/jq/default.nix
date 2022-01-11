{ buildPythonPackage, fetchPypi, lib, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "73ce588025495e6ebcda20bb9e64b6d9f3f1657c22895143ae243899ac710cbc";
  };

  patches = [
    # Removes vendoring
    ./jq-py-setup.patch
  ];

  buildInputs = [ jq ];

  # no tests executed
  doCheck = false;
  pythonImportsCheck = [ "jq" ];

  meta = {
    description = "Python bindings for jq, the flexible JSON processor";
    homepage = "https://github.com/mwilliamson/jq.py";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ benley ];
  };
}
