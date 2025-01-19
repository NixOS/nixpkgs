{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  attrs,
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.24.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    hash = "sha256-IwLYJ3ltUqqHpFfiBKWcbluzB3ks0xN5qchfZJSkpZo=";
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
