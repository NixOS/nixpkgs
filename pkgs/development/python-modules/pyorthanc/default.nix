{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx,
  pydicom,
}:

buildPythonPackage rec {
  pname = "pyorthanc";
  version = "1.19.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = "pyorthanc";
    tag = "v${version}";
    hash = "sha256-97i341NXb7QsgN0X808mtz1rSKYSP+SMoGJy43Tkwug=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "pydicom"
  ];

  dependencies = [
    httpx
    pydicom
  ];

  doCheck = false; # requires orthanc server (not in Nixpkgs)

  pythonImportsCheck = [ "pyorthanc" ];

  meta = {
    description = "Python library that wraps the Orthanc REST API";
    homepage = "https://github.com/gacou54/pyorthanc";
    changelog = "https://github.com/gacou54/pyorthanc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
