{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  llvmPackages,
  zlib,
  cython,
  numpy,
  setuptools,
  versioneer,
  wheel,
  astunparse,
  netcdf4,
  packaging,
  pyparsing,
  scipy,
  gsd,
  networkx,
  pandas,
  pytest-xdist,
  pytestCheckHook,
  tables,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "mdtraj";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdtraj";
    repo = "mdtraj";
    tag = version;
    hash = "sha256-Re8noXZGT+WEW8HzdoHSsr52R06TzLPzfPzHdvweRdQ=";
  };

  patches = [
    # disable intrinsics when SIMD is not available
    # TODO: enable SIMD with python3.12
    # https://github.com/mdtraj/mdtraj/pull/1884
    (fetchpatch {
      name = "fix-intrinsics-flag.patch";
      url = "https://github.com/mdtraj/mdtraj/commit/d6041c645d51898e2a09030633210213eec7d4c5.patch";
      hash = "sha256-kcnlHMoA/exJzV8iQltH+LWXrvSk7gsUV+yWK6xn0jg=";
    })
  ];

  build-system = [
    cython
    numpy
    setuptools
    versioneer
    wheel
  ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [
    netcdf4
    numpy
    packaging
    pyparsing
    scipy
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-incompatible-function-pointer-types";

  nativeCheckInputs = [
    gsd
    networkx
    pandas
    pytest-xdist
    pytestCheckHook
    tables
  ];

  preCheck = ''
    cd tests
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # require network access
    "test_pdb_from_url"
    "test_1vii_url_and_gz"
    "test_3"

    # fail due to data race
    "test_read_atomindices_1"
    "test_read_atomindices_2"

    # flaky test
    "test_compare_rdf_t_master"
    "test_distances_t"
    "test_precentered_2"
  ];

  # these files import distutils
  # remove once https://github.com/mdtraj/mdtraj/pull/1916 is merged
  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    "test_mol2.py"
    "test_netcdf.py"
  ];

  pythonImportsCheck = [ "mdtraj" ];

  meta = with lib; {
    description = "Open library for the analysis of molecular dynamics trajectories";
    homepage = "https://github.com/mdtraj/mdtraj";
    changelog = "https://github.com/mdtraj/mdtraj/releases/tag/${src.tag}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ natsukium ];
  };
}
