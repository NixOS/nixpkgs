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
  version = "1.21.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = "pyorthanc";
    tag = "v${version}";
    hash = "sha256-293H5hQ+6eknzKNsZpVKoTcrKzbHfJE4C+SyxAOLphY=";
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
