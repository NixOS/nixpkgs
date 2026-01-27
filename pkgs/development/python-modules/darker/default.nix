{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  # dependencies
  toml,
  typing-extensions,
  darkgraylib,
}:

buildPythonPackage rec {
  pname = "darker";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "darker";
    tag = "v${version}";
    hash = "sha256-O0WS0HQfwXaO04ciYAkumSCqKkyYTnoW5g3LRhZ8ko8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    toml
    typing-extensions
    darkgraylib
  ];

  meta = {
    homepage = "https://github.com/akaihola/darker";
    description = "Incremental formatting for python projects";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hackeryarn ];
    mainProgram = "darker";
  };
}
