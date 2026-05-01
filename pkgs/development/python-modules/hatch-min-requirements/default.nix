{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
}:

buildPythonPackage rec {
  pname = "hatch-min-requirements";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tlambert03";
    repo = "hatch-min-requirements";
    tag = "v${version}";
    hash = "sha256-7/6Es0DHDJ8jZ76kVbWkQjWFd8hWuB+PwCbOmIjzK5o=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  # As of v0.1.0 all tests attempt to use the network
  doCheck = false;

  pythonImportsCheck = [ "hatch_min_requirements" ];

  meta = {
    description = "Hatchling plugin to create optional-dependencies pinned to minimum versions";
    homepage = "https://github.com/tlambert03/hatch-min-requirements";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      samuela
    ];
  };
}
