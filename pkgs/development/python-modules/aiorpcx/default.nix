{ lib, fetchPypi, buildPythonPackage, pythonOlder, attrs }:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.10.2";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "1p88k15jh0d2a18pnnbfcamsqi2bxvmmhpizmdlxfdxf8vy5ggyj";
  };

  propagatedBuildInputs = [ attrs ];

  disabled = pythonOlder "3.6";

  # Checks needs internet access
  doCheck = false;

  meta = {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    license = lib.licenses.mit;
    homepage = https://github.com/kyuupichan/aiorpcX;
  };
}
