{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorful";
  version = "0.5.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "timofurrer";
    repo = "colorful";
    tag = "v${version}";
    hash = "sha256-nztVTfBimRDXwPYk3LNMZKa1ItbgqM2ukgZs8hI8TwE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "colorful" ];

  passthru.updateScript = gitUpdater {
    # Drop the "v" tag prefix before version comparison.
    rev-prefix = "v";
    # Skip PEP 440 pre-release tags.
    ignoredVersions = "(a|b|rc)[0-9]+$";
  };

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
