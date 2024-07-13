{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "doorbirdpy";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "klikini";
    repo = "doorbirdpy";
    rev = version;
    hash = "sha256-6B4EMK41vEpmLoQLD+XN9yStLdxyHHk/Mym9J0o7Qvc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "doorbirdpy" ];

  meta = with lib; {
    description = "Python wrapper for the DoorBird LAN API";
    homepage = "https://gitlab.com/klikini/doorbirdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
