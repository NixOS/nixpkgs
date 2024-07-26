{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pybluez,
  pytestCheckHook,
  pythonOlder,
  pyusb,
}:

buildPythonPackage rec {
  pname = "nxt-python";
  version = "3.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "schodet";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-v65KEP5DuJsZAifd1Rh46x9lSAgBZgyo+e8PKSDKnhw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pyusb ];

  optional-dependencies = {
    bluetooth = [ pybluez ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nxt" ];

  meta = with lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = "https://github.com/schodet/nxt-python";
    changelog = "https://github.com/schodet/nxt-python/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ibizaman ];
  };
}
