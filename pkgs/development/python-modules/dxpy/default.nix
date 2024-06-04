{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchgit,

  # runtime dependencies
  certifi,
  urllib3,
  python-dateutil,
  websocket-client,
  argcomplete,
  psutil,
}:

buildPythonPackage rec {
  pname = "dxpy";
  version = "0.377.0";

  disabled = pythonOlder "3.8";

  src = "${fetchgit {
    url = "https://github.com/dnanexus/dx-toolkit.git";
    rev = "v0.377.0";
    hash = "sha256-xcUSl5C9XKFc0TQh7wJPeTP7syZCwU5BWo55mtSBdN0=";
  }}/src/python";

  dependencies = [
    certifi
    urllib3
    python-dateutil
    websocket-client
    argcomplete
    psutil
  ];

  doCheck = false;

  pythonImportChecks = [
    "dxpy"
  ];

  meta = {
    changelog = "https://github.com/dnanexus/dx-toolkit/blob/master/CHANGELOG.md";
    description = "DNAnexus Python API";
    homepage = "https://github.com/dnanexus/dx-toolkit/tree/master/src/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [giang];
  };
}
