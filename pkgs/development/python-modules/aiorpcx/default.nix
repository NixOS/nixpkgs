{ lib, fetchPypi, buildPythonPackage, pythonOlder, attrs }:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.10.4";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "15jhklvl0ncy3mb2h9zkahky9fzzr1amgjylm2k3mvlpyn2dbpz6";
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
