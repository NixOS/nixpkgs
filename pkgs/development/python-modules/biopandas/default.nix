{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  looseversion,
  mmtf-python,
  numpy,
  pandas,
  pynose,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biopandas";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BioPandas";
    repo = "biopandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-1c78baBBsDyvAWrNx5mZI/Q75wyXv0DAwAdWm3EwX/I=";
  };


  pythonRelaxDeps = [ "looseversion" ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    pandas
    mmtf-python
    looseversion
  ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

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
    changelog = "https://github.com/BioPandas/biopandas/releases/tag/${src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
