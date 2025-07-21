{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  flit-core,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-unmagic";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimagi";
    repo = "pytest-unmagic";
    tag = "v${version}";
    hash = "sha256-5WnLjQ0RuwLBIZAbOJoQ0KBEnb7yUWTUFBKy+WgNctQ=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unmagic" ];

  meta = {
    description = "Pytest fixtures with conventional import semantics";
    homepage = "https://github.com/dimagi/pytest-unmagic";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
