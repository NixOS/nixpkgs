{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "confuse";
    rev = "v${version}";
    hash = "sha256-RKiHYAFEvksRLsXC1VrlrKzkPl72dDI4O0Y+X3MrpSs=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "confuse" ];

  meta = {
    description = "Python configuration library for Python that uses YAML";
    homepage = "https://github.com/beetbox/confuse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lovesegfault
      doronbehar
    ];
  };
}
