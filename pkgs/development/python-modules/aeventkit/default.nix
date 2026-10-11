{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aeventkit";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ib-api-reloaded";
    repo = "eventkit";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-0u7yeW2C27XqMPakcKZdXwg/F50vyLb6LX/JDLOkqHg=";
  };

  build-system = [ poetry-core ];
  dependencies = [
    numpy
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python sync/async framework for Interactive Brokers API";
    maintainers = [ lib.maintainers.supermarin ];
    homepage = "https://github.com/ib-api-reloaded/eventkit";
    license = lib.licenses.bsd2;
  };
})
