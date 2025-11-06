{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "iglo";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jesserockz";
    repo = "python-iglo";
    tag = "v${version}";
    hash = "sha256-torDjfQcQ+ytv/Qab7PNugt1eLQJ0pPPz6p4f4kcFws=";
  };

  sourceRoot = "${src.name}/src";

  build-system = [ setuptools ];

  # Package has no tests
  doCheck = false;

  pythonImportsCheck = [ "iglo" ];

  meta = {
    description = "Library to control iGlo based RGB lights";
    homepage = "https://github.com/jesserockz/python-iglo";
    changelog = "https://github.com/jesserockz/python-iglo/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
