{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  attrs,
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.23.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    hash = "sha256-WyMALxpNXTCF4xVVoHUZxe+NTEAHHrSZVW/9qBFIYKI=";
  };

  propagatedBuildInputs = [ attrs ];

  disabled = pythonOlder "3.6";

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiorpcx" ];

  meta = {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
