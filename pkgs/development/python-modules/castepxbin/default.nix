{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  numpy,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "castepxbin";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhubonan";
    repo = "castepxbin";
    tag = "v${version}";
    hash = "sha256-M+OoKr9ODIp47gt64hf47A1PblyZpBzulKI7nEm8hdo=";
  };

  build-system = [ flit-core ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/zhubonan/castepxbin/releases/tag/${src.tag}";
    description = "Collection of readers for CASTEP binary outputs";
    homepage = "https://github.com/zhubonan/castepxbin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
