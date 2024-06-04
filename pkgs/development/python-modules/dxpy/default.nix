{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,

  # runtime dependencies
  certifi,
  urllib3,
  python-dateutil,
  websocket-client,
  argcomplete,
  psutil,

  # optional dependencies
  xattr,
}:

let
  urllib3_210 = urllib3.overrideAttrs (
    { pname, ... }:
    rec {
      inherit pname;
      version = "2.1.0";
      src = fetchPypi {
        inherit pname version;
        hash = "sha256-33qor7AUj6eEiOeJmyxZtfT/z6gubFTMud03wde1LVQ=";
      };
    }
  );
in
buildPythonPackage rec {
  pname = "dxpy";
  version = "0.379.0";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cc8eQYvg/JHdI+6RboPqzR9fO6qJckhPcT4c1O0IH/E=";
  };

  dependencies = [
    certifi
    urllib3_210
    python-dateutil
    websocket-client
    argcomplete
    psutil
  ];

  passthru.optional-dependencies = [ xattr ];

  # Tests require pandas 1.3.5, which requires too much compilation effort (in Nix).
  doCheck = false;

  pythonImportChecks = [ "dxpy" ];

  meta = {
    changelog = "https://github.com/dnanexus/dx-toolkit/blob/v0.379.0/CHANGELOG.md";
    description = "DNAnexus Platform API bindings";
    homepage = "https://github.com/dnanexus/dx-toolkit/tree/v0.379.0/src/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ giang ];
    mainProgram = "dx";
  };
}
