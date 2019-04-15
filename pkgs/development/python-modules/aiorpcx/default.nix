{ lib, fetchPypi, buildPythonPackage, pythonOlder, attrs }:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.13.5";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "0lyjr1hq4qysm0xpgd25wwc4ajw9p3bm8nq9cqhjh7bq6v58c5bw";
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
