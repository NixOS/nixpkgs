{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pdm-backend,
  tomli,
  build,
  hatchling,
  pkginfo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pdm-build-locked";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm-build-locked";
    tag = version;
    hash = "sha256-ONDKW3KIOKnrOWD/T/W7Do/4/CfgET4TpfYcLha5mVg=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail '"pdm.pytest"' ""
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [ pdm-backend ];

  dependencies = lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "pdm_build_locked" ];

  nativeCheckInputs = [
    build
    hatchling
    pkginfo
    pytestCheckHook
  ];

  disabledTestPaths = [
    # circular import of pdm
    "tests/unit/test_build_command.py"
  ];

  meta = {
    description = "Pdm-build-locked is a pdm plugin to publish locked dependencies as optional-dependencies";
    homepage = "https://github.com/pdm-project/pdm-build-locked";
    changelog = "https://github.com/pdm-project/pdm-build-locked/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
