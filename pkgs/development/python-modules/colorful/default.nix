{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "colorful";
    tag = "v${version}";
    hash = "sha256-iJ63Txn8wbZFlBrplTiHfkMfrCZfXxqlPRQgaMrwHCo=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

  meta = {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
