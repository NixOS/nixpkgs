{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pydexcom";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gagebenne";
    repo = "pydexcom";
    rev = "refs/tags/${version}";
    hash = "sha256-cf3AhqaA5aij2NCeFqruoeE0ovJSgZgEnVHcE3iXJ1s=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [ requests ];

  # Tests are interacting with the Dexcom API
  doCheck = false;

  pythonImportsCheck = [ "pydexcom" ];

  meta = with lib; {
    description = "Python API to interact with Dexcom Share service";
    homepage = "https://github.com/gagebenne/pydexcom";
    changelog = "https://github.com/gagebenne/pydexcom/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
