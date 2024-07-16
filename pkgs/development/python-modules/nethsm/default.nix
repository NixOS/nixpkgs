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
  version = "1.2.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BFdnRHHe/UIusZn1JdV3Fc6W5TtJAMk4e8masEYrqdQ=";
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
