{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "esper";
  version = "3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benmoran56";
    repo = "esper";
    rev = "refs/tags/v${version}";
    hash = "sha256-oH3POxrQPge9BZHG5Y/n9/sWjiCA19mqpoCZfPM6BzA=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "esper" ];

  meta = {
    description = "An ECS (Entity Component System) for Python";
    homepage = "https://github.com/benmoran56/esper";
    changelog = "https://github.com/benmoran56/esper/blob/${src.rev}/RELEASE_NOTES";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
