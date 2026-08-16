{
  lib,
  hatchling,
  alembic,
  buildPythonPackage,
  fetchFromGitHub,
  sqlalchemy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "dataset";
    tag = version;
    hash = "sha256-A8X1Gv+b+K90LAZ5YDjeUbl3Y1fiaFwGj6urapLN3AQ=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    alembic
    sqlalchemy
  ];

  pythonImportsCheck = [ "dataset" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Toolkit for Python-based database access";
    homepage = "https://dataset.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xfnw ];
  };
}
