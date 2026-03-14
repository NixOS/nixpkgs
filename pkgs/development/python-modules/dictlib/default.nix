{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "dictlib";
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "srevenant";
    repo = "dictlib";
    # The project does not provide versioned Git tags.
    # This commit sets the package version to 1.1.5 and was the latest commit at the time of packaging (2025).
    rev = "f8b073cca2a4e5ac955c6818961a4e5146a5eb1e";
    hash = "sha256-iYnCtjccZyDZOKW4VKouKLMH93/lpuVp7GwNQLFpkBc=";
  };

  build-system = [ setuptools ];

  doCheck = true;

  meta = {
    description = "Lightweight add-on for dictionaries";
    homepage = "https://github.com/srevenant/dictlib";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ bbenno ];
  };
}
