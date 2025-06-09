{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyjwt,
  pythonOlder,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pyixapi";
  version = "0.2.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "peering-manager";
    repo = "pyixapi";
    tag = version;
    hash = "sha256-NS8rVzLpEtpuLal6sApXI3hjASiIeXZuZ4xyj9Zv1k0=";
  };

  pythonRelaxDeps = [ "pyjwt" ];

  build-system = [ poetry-core ];

  dependencies = [
    requests
    pyjwt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyixapi" ];

  meta = with lib; {
    description = "Python API client library for IX-API";
    homepage = "https://github.com/peering-manager/pyixapi/";
    changelog = "https://github.com/peering-manager/pyixapi/releases/tag/${src.tag}";
    license = licenses.asl20;
    teams = [ teams.wdz ];
  };
}
