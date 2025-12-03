{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  persim,
  scikit-learn,
  scipy,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "ripser";
  version = "0.6.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-tda";
    repo = "ripser.py";
    tag = "v${version}";
    hash = "sha256-AviAcpaK0UWqa6spba9bLmBQnprINCrZC/wuRLqiXVA=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    scikit-learn
    persim
  ];

  pythonImportsCheck = [ "ripser" ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # specifically needed for darwin
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError
    # assert np.isinf(h0[0, 1])
    "test_full_nonzerobirths"
    # assert np.max(np.abs(h11 - h12)) <= 2 * res2["r_cover"]
    "test_greedyperm_circlebottleneck"
    # assert np.all(dgm[:,1] >= dgm[:,0])
    "test_returns_dgm"
    # assert tuple(dgm[0]) == (0,np.inf)
    # assert (np.float64(0....float64(0.0)) == (0, inf)
    "test_single_point"
    # assert res0["num_edges"] == res1["num_edges"]
    # assert 2307 == 167
    "test_sparse"
    # assert 38 < 38
    "test_thresh"
    # assert(np.allclose(r1, r2))
    "test_zero_edge_bug"
    # assert (0, 2) == (1, 2)
    "test_verbose_true"
    # assert (0, 2) == (1, 2)
    "test_verbose_false"
  ];

  meta = {
    description = "Lean Persistent Homology Library for Python";
    homepage = "https://ripser.scikit-tda.org";
    changelog = "https://github.com/scikit-tda/ripser.py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
