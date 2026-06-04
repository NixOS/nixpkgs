{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.6.0a1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "colorful";
    tag = "v${version}";
    hash = "sha256-6ed7RgaYAr4eUtaiD4o+gJhgIWYA3wFR32nHoazV10s=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

  meta = {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      l33tname
    ];
  };
}
