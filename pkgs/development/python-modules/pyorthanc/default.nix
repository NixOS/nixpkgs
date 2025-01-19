{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  httpx,
  pydicom,
}:

buildPythonPackage rec {
  pname = "pyorthanc";
  version = "1.19.0";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-6//kmkurtaXRGvnYnk/kU2j9F6V1Aui6IEdl+3DHGH0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydicom
  ];

  doCheck = false; # requires orthanc server (not in Nixpkgs)

  pythonImportsCheck = [ "pyorthanc" ];

  meta = with lib; {
    description = "Python library that wraps the Orthanc REST API";
    homepage = "https://github.com/gacou54/pyorthanc";
    changelog = "https://github.com/gacou54/pyorthanc/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
