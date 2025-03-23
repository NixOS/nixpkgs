{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  certifi,
  cryptography,
  python-dateutil,
  typing-extensions,
  urllib3,
}:

let
  pname = "nethsm";
  version = "1.3.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F0jSlT/xM8xaQWfUp87p+2RY/8hG7vRq8/VJ4a5Fkhw=";
  };

  propagatedBuildInputs = [
    certifi
    cryptography
    python-dateutil
    typing-extensions
    urllib3
  ];

  nativeBuildInputs = [
    flit-core
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "nethsm" ];

  meta = with lib; {
    description = "Client-side Python SDK for NetHSM";
    homepage = "https://github.com/Nitrokey/nethsm-sdk-py";
    changelog = "https://github.com/Nitrokey/nethsm-sdk-py/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ frogamic ];
  };
}
