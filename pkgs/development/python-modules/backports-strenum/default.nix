{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "backports-strenum";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "clbarnes";
    repo = "backports.strenum";
    tag = "v${version}";
    hash = "sha256-j5tALFrLeZ8k+GwAaq0ocmcQWvdWkRUHbOVq5Du4mu0=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "backports.strenum" ];

  meta = {
    description = "Base class for creating enumerated constants that are also subclasses of str";
    homepage = "https://github.com/clbarnes/backports.strenum";
    license = with lib.licenses; [ psfl ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
