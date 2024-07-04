{
  lib,
  buildPythonPackage,
  diagrams,
  fetchFromGitHub,
  osc-sdk-python,
  setuptools,
}:

buildPythonPackage {
  pname = "osc-diagram";
  version = "unstable-2023-08-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale-mgo";
    repo = "osc-diagram";
    rev = "8531233b8a95da03aca9106064b91479197f888d";
    hash = "sha256-2Iaar2twemw4xv1GGqHd3xiNCHrZLsZXtP7e9tNVpEU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    diagrams
    osc-sdk-python
  ];

  pythonImportsCheck = [ "osc_diagram" ];

  meta = with lib; {
    description = "Build Outscale cloud diagrams";
    mainProgram = "osc-diagram";
    homepage = "https://github.com/outscale-mgo/osc-diagram";
    license = licenses.free;
    maintainers = with maintainers; [ nicolas-goudry ];
  };
}
