{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autoslot";
  version = "2025.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cjrh";
    repo = "autoslot";
    tag = "v${version}";
    hash = "sha256-mPGfBUSKkskiiokqo/TJWdDzuvcg/LDULx+Gx8LexV8=";
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
