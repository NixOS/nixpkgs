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
  version = "0.2.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "peering-manager";
    repo = "pyixapi";
    tag = version;
    hash = "sha256-pKIm9YCWf5HCwJ76NLm6AmcJWGVErZu9dwl23p8maXs=";
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
