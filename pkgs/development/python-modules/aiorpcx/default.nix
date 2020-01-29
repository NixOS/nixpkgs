{ lib, fetchPypi, buildPythonPackage, pythonOlder, attrs }:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.18.4";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "0jpvrkan6w8bpq017m8si7r9hb1pyw3ip4vr1fl2pmi8ngzc1jdy";
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
