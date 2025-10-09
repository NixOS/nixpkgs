{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "autoslot";
  version = "2024.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "autoslot";
    tag = "v${version}";
    hash = "sha256-wYjsBrjvSZFHDt0HLrnS9Xwk8EHVQupfPSkQnUFmMAk=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autoslot" ];

  meta = with lib; {
    description = "Automatic __slots__ for your Python classes";
    homepage = "https://github.com/cjrh/autoslot";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
