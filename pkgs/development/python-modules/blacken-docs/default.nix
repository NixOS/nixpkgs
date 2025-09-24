{
  black,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "blacken-docs";
  version = "1.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "blacken-docs";
    tag = version;
    hash = "sha256-cMnwOrkOma+su4CDheHRd484pG4GMSm+i/Xcus3E+m8=";
  };

  build-system = [ setuptools ];

  dependencies = [ black ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/adamchainz/blacken-docs";
    changelog = "https://github.com/adamchainz/blacken-docs/blob/${src.rev}/CHANGELOG.rst";
    description = "Run Black on Python code blocks in documentation files";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.l0b0 ];
    mainProgram = "blacken-docs";
  };
}
