{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mslex,
}:

buildPythonPackage rec {
  pname = "oslex";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petamas";
    repo = "oslex";
    tag = "release/v${version}";
    hash = "sha256-OcmBtxGS1Cq2kEcxF0Il62LUGbAAcG4lieokr/nK2/4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    mslex
  ];

  pythonImportsCheck = [
    "oslex"
  ];

  meta = {
    description = "OS-independent wrapper for shlex and mslex";
    homepage = "https://github.com/petamas/oslex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yzx9 ];
  };
}
