{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  asciitree,
  click,
  cytoolz,
  h5py,
  multiprocess,
  numpy,
  pandas,
  pyfaidx,
  pyyaml,
  scipy,
  simplejson,

  # tests
  biopython,
  dask,
  hypothesis,
  matplotlib,
  pyarrow,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cooler";
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open2c";
    repo = "cooler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eD7nJhYtikGc2OwSn5XQXQWT5u+04v6vBiWR2oiaOj0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    asciitree
    click
    cytoolz
    h5py
    multiprocess
    numpy
    pandas
    pyfaidx
    pyyaml
    scipy
    simplejson
  ];

  nativeCheckInputs = [
    biopython
    dask
    hypothesis
    matplotlib
    pyarrow
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_roundtrip"

    # Requires ipytree, which is not packaged
    "test_print_trees"
  ];

  pythonImportsCheck = [ "cooler" ];

  meta = {
    description = "Sparse binary format for genomic interaction matrices";
    homepage = "https://github.com/open2c/cooler";
    changelog = "https://github.com/open2c/cooler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hoseok-lee ];
  };
})
