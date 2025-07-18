{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  immutabledict,
  pytools,

  # optional-dependencies
  matchpy,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2024.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pymbolic";
    tag = "v${version}";
    hash = "sha256-07RWdEPhO+n9/FOvIWe4nm9fGekut9X6Tz4HlIkBSpo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    immutabledict
    pytools
  ];

  optional-dependencies = {
    matchpy = [ matchpy ];
    numpy = [ numpy ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "pymbolic" ];

  meta = {
    description = "Package for symbolic computation";
    homepage = "https://documen.tician.de/pymbolic/";
    changelog = "https://github.com/inducer/pymbolic/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
