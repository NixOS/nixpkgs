{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
}:

buildPythonPackage rec {
  pname = "hatch-deps-selector";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "hatch-deps-selector";
    tag = "v${version}";
    hash = "sha256-AaHVBUDENF3d+yzDt5mvMnfqO+DSYQafMdHNDyEtz2s=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [ "hatch_deps_selector" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Select additional dependencies for pyproject.toml from the environment";
    homepage = "https://github.com/jupyter-book/hatch-deps-selector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
