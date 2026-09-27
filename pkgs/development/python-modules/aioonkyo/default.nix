{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aioonkyo";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "arturpragacz";
    repo = "aioonkyo";
    tag = version;
    hash = "sha256-hLtyQWChWBddefDUT/+7e/w6i/DPEm/zw+EqOPgGsUI=";
  };

  build-system = [ hatchling ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioonkyo" ];

  meta = {
    description = "Library for controlling Onkyo AV receivers";
    homepage = "https://github.com/arturpragacz/aioonkyo";
    changelog = "https://github.com/arturpragacz/aioonkyo/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
