{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  flit-core,

  # dependencies
  pyyaml,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "confuse";
    rev = "v${version}";
    hash = "sha256-TVx0cBXv/fIuli/xrFXBAmwJ1rQr5xJL1Q67FaDr4ow=";
  };

  build-system = [
    flit-core
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
