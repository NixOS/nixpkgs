{ buildPythonPackage, fetchPypi, lib, jq }:

buildPythonPackage rec {
  pname = "jq";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77e747c6ad10ce65479f5f9064ab036483bf307bf71fdd7d6235ef895fcc506e";
  };

  patches = [ ./jq-py-setup.patch ];

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
