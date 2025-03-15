{
  lib,
  backports-strenum,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "archinfo";
  version = "9.2.146";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "archinfo";
    tag = "v${version}";
    hash = "sha256-8JlIhLqVPNm3P2ruJh5i7VxnnBXfubLzhtFnWF3RWf8=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ backports-strenum ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "archinfo" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Classes with architecture-specific information";
    homepage = "https://github.com/angr/archinfo";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
