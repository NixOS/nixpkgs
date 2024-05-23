{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8rHJIsHiyfjmjlGiEyrzvEwKgi1kP4Njm731mlFDMIU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

  meta = with lib; {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
