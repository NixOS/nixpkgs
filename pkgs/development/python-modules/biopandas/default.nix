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
  fetchpatch2,
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

  patches = [
    # Needed for below patch to apply properly
    (fetchpatch2 {
      name = "deprecate-mmtf-parsing.patch";
      url = "https://github.com/BioPandas/biopandas/commit/7a1517dbe76f2c70da8edb35f90c9fa69254e726.patch?full_index=1";
      hash = "sha256-RFtXFqUYl8GnZ319HsBwx5SUbfUDnR66Ppakdvtg/wI=";
    })
    # Remove nose as a dependency.
    (fetchpatch2 {
      name = "remove-nose.patch";
      url = "https://github.com/BioPandas/biopandas/commit/67aa2f237c70c826cd9ab59d6ae114582da2112f.patch?full_index=1";
      hash = "sha256-fVl57/vGuzlYX/MBZnma1ZFCVmIpjr1k8t3bUJnb/uI=";
      excludes = [ "setup.py" ];
    })
  ];

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
