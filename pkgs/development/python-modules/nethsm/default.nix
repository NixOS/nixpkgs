{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, flit-core
, certifi
, cryptography
, python-dateutil
, typing-extensions
, urllib3
}:

let
  pname = "nethsm";
  version = "1.0.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sENuSdA4pYt8v2w2RvDkcQLYCP9V0vZOdWOlkNBi3/o=";
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
    pythonRelaxDepsHook
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
