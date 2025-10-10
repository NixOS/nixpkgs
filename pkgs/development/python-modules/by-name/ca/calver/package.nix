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
    version = "2025.04.17";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "di";
      repo = "calver";
      tag = version;
      hash = "sha256-C0l/SThDhA1DnOeMJfuh3d8R606nzyQag+cg7QqvYWY=";
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

    pythonImportsCheck = [ "calver" ];

    passthru.tests.calver = self.overridePythonAttrs { doCheck = true; };

    meta = {
      changelog = "https://github.com/di/calver/releases/tag/${src.tag}";
      description = "Setuptools extension for CalVer package versions";
      homepage = "https://github.com/di/calver";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
self
