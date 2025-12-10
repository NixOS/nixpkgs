{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "colorful";
    tag = "v${version}";
    hash = "sha256-nztVTfBimRDXwPYk3LNMZKa1ItbgqM2ukgZs8hI8TwE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

  meta = with lib; {
    description = "Library for terminal string styling";
    homepage = "https://github.com/timofurrer/colorful";
    changelog = "https://github.com/timofurrer/colorful/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [
      kalbasit
      l33tname
    ];
  };
}
