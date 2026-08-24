{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "ci-info";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "ci_info";
    inherit (finalAttrs) version;
    hash = "sha256-NNWhhyazeAq9+YUjS4cawzEk1k3Y4pSHC4zFtBDBhBg=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  doCheck = false; # both tests access network

  pythonImportsCheck = [ "ci_info" ];

  meta = {
    description = "Gather continuous integration information on the fly";
    homepage = "https://github.com/mgxd/ci-info";
    changelog = "https://github.com/mgxd/ci-info/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
