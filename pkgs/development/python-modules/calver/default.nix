{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretend,
  pytestCheckHook,
  setuptools,
}:

let
  self = buildPythonPackage rec {
    pname = "calver";
    version = "2025.04.01";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "di";
      repo = "calver";
      rev = version;
      hash = "sha256-F7OnhwlwCw6cZeigmzyyIkttQMfxFoC2ynpxw0FGYMo=";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace "version=calver_version(True)" 'version="${version}"'
    '';

    build-system = [ setuptools ];

    doCheck = false; # avoid infinite recursion with hatchling

    nativeCheckInputs = [
      pretend
      pytestCheckHook
    ];

    preCheck = ''
      unset SOURCE_DATE_EPOCH
    '';

    pythonImportsCheck = [ "calver" ];

    passthru.tests.calver = self.overridePythonAttrs { doCheck = true; };

    meta = {
      changelog = "https://github.com/di/calver/releases/tag/${src.rev}";
      description = "Setuptools extension for CalVer package versions";
      homepage = "https://github.com/di/calver";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
self
