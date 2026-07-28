{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  pyyaml,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "confuse";
    rev = "v${version}";
    hash = "sha256-lux4tYf3QC4pd1VnSzpw70wwUD4ovsOqanq3IGhTBOU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyyaml
    typing-extensions
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
