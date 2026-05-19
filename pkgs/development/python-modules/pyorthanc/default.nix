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
  version = "1.23.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = "pyorthanc";
    tag = "v${version}";
    hash = "sha256-L1vIU6oDZ95lFt2w/TYFpHdmHmDE2XPn10XdEUIlxRQ=";
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
    changelog = "https://github.com/gacou54/pyorthanc/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
