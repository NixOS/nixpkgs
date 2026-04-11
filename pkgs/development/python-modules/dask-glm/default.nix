{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  cloudpickle,
  distributed,
  multipledispatch,
  scikit-learn,
  scipy,
  sparse,
  dask,

  # tests
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-glm";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-glm";
    tag = version;
    hash = "sha256-q98QMmw1toashimS16of54cgZgIPqkua3xGD1FZ1nTc=";
  };

  # ValueError: The truth value of an empty array is ambiguous. Use `array.size > 0` to check that an array is not empty.
  postPatch = ''
    substituteInPlace dask_glm/utils.py \
      --replace-fail "if arr:" "if (arr is not None) and (arr.size > 0):"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    cloudpickle
    distributed
    multipledispatch
    scikit-learn
    scipy
    sparse
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dask_glm" ];

  disabledTests = [
    # ValueError: <class 'bool'> can be computed for one-element arrays only.
    "test_dot_with_sparse"

    # ValueError: `shape` was not provided.
    "test_sparse"
  ];

  # On darwin, tests saturate the entire system, even when constrained to run single-threaded
  # Removing pytest-xdist AND setting --cores to one does not prevent the load from exploding
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Generalized Linear Models with Dask";
    homepage = "https://github.com/dask/dask-glm/";
    changelog = "https://github.com/dask/dask-glm/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
