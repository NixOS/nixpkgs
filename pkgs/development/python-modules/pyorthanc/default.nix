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
  version = "1.18.0";
  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ObZjTiEB4a7ForsugzKZDdIsTEWOX1zbv53ZJ4AllHE=";
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
    changelog = "https://github.com/gacou54/pyorthanc/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
