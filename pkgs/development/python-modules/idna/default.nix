{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kjd";
    repo = "idna";
    tag = "v${version}";
    hash = "sha256-z3Nd834inihGzquCAmejUQvRcM0Yn/VmMcWQP3oh4ak=";
  };

  build-system = [ flit-core ];

  pythonImportsCheck = [ "idna" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    changelog = "https://github.com/kjd/idna/releases/tag/${src.tag}";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
