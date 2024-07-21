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
  version = "1.1.0";
in

buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CQhheHQ0BlfznKjoOSRvbDtnlTvv/SLtl0GWd7LUSt8=";
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
