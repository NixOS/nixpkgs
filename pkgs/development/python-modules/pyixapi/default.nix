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
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "peering-manager";
    repo = "pyixapi";
    rev = "refs/tags/${version}";
    hash = "sha256-IiLjxOtyxGSaItxgEbsF8AER/j4Qe7SP9ZAEPjTiYI4=";
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
    changelog = "https://github.com/peering-manager/pyixapi/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.wdz.members;
  };
}
