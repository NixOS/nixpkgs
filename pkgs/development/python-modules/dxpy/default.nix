{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

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

  src = fetchFromGitHub {
    owner = "dnanexus";
    repo = "dx-toolkit";
    rev = "v${version}";
    hash = "sha256-xcUSl5C9XKFc0TQh7wJPeTP7syZCwU5BWo55mtSBdN0=";
  };

  sourceRoot = "${src.name}/src/python";

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
    changelog = "https://github.com/dnanexus/dx-toolkit/blob/${src.rev}/CHANGELOG.md";
    description = "DNAnexus Python API";
    homepage = "https://github.com/dnanexus/dx-toolkit/tree/${src.rev}/src/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [giang];
    mainProgram = "dx";
  };
}
