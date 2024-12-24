{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  looseversion,
  mmtf-python,
  numpy,
  pandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biopandas";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BioPandas";
    repo = "biopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-dUeGjDDz9VA1NrFLGKy0ebaa+MU4c1tHi5YYkAspLRk=";
  };

  pythonRelaxDeps = [ "looseversion" ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    mmtf-python
    looseversion
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # require network access
    "test_mmcif_pdb_conversion"
    "test_fetch_pdb"
    "test_write_mmtf_bp"
    "test_write_mmtf"
    "test_b_factor_shift"
  ];

  pythonImportsCheck = [ "biopandas" ];

  meta = {
    description = "Working with molecular structures in pandas DataFrames";
    homepage = "https://github.com/BioPandas/biopandas";
    changelog = "https://github.com/BioPandas/biopandas/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
