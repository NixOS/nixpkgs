{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  constantdict,
  pytools,
  typing-extensions,

  # optional-dependencies
  matchpy,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2025.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "pymbolic";
    tag = "v${version}";
    hash = "sha256-cn2EdhMn5qjK854AF5AY4Hv4M5Ib6gPRJk+kQvsFWRk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    constantdict
    pytools
    typing-extensions
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
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
