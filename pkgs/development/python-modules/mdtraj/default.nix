{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  llvmPackages,
  zlib,
  cython_0,
  oldest-supported-numpy,
  setuptools,
  wheel,
  astunparse,
  numpy,
  packaging,
  pyparsing,
  scipy,
  gsd,
  networkx,
  pandas,
  pytest-xdist,
  pytestCheckHook,
  tables,
}:

buildPythonPackage rec {
  pname = "mdtraj";
  version = "1.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdtraj";
    repo = "mdtraj";
    rev = "refs/tags/${version}";
    hash = "sha256-2Jg6DyVJlRBLD/6hMtcsrAdxKF5RkpUuhAQm/lqVGeE=";
  };

  patches = [
    (fetchpatch {
      name = "gsd_3-compatibility.patch";
      url = "https://github.com/mdtraj/mdtraj/commit/81209d00817ab07cfc4668bf5ec88088d16904c0.patch";
      hash = "sha256-ttNmij7csxF0Z5wPPwhGumRX055W2IgFjRAe6nI6GNY=";
    })
    # remove pkg_resources usage
    # https://github.com/mdtraj/mdtraj/pull/1837
    (fetchpatch {
      name = "fix-runtime-error.patch";
      url = "https://github.com/mdtraj/mdtraj/commit/02d44d4db7039fceb199c85b4f993244804f470d.patch";
      hash = "sha256-nhbi3iOrDSM87DyIp1KVt383Vvb6aYOgkjuYzviqiq8=";
    })
    # remove distutils usage
    # https://github.com/mdtraj/mdtraj/pull/1834
    (fetchpatch {
      name = "python312-compatibility.patch";
      url = "https://github.com/mdtraj/mdtraj/commit/95d79747deef42c976ca362a57806b61933409f3.patch";
      hash = "sha256-Cq7/d745q6ZgAyWGM4ULnSsWezsbnu1CjSz5eqYSb+g=";
    })
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
    cython_0
    oldest-supported-numpy
    setuptools
    wheel
  ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [
    astunparse
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

    # fail due to data race
    "test_read_atomindices_1"
    "test_read_atomindices_2"

    # flaky test
    "test_compare_rdf_t_master"
    "test_distances_t"
    "test_precentered_2"
  ];

  pythonImportsCheck = [ "mdtraj" ];

  meta = with lib; {
    description = "An open library for the analysis of molecular dynamics trajectories";
    homepage = "https://github.com/mdtraj/mdtraj";
    changelog = "https://github.com/mdtraj/mdtraj/releases/tag/${src.rev}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ natsukium ];
  };
}
