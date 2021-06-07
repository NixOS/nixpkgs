{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, attrs
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.18.7";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "808a9ec9172df11677a0f7b459b69d1a6cf8b19c19da55541fa31fb1afce5ce7";
  };

  propagatedBuildInputs = [ attrs ];

  disabled = pythonOlder "3.6";

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiorpcx" ];

  meta = with lib; {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
