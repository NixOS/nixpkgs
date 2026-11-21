{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  astropy,
  corner,
  dill,
  emcee,
  h5py,
  jinja2,
  matplotlib,
  multiprocess,
  pandas,
  python-dateutil,
  scipy,
  tables,
  ultranest,

  # optional-dependencies
  aiosqlite,
  fastapi,
  httpx,
  pydantic,
  pydantic-settings,
  python-multipart,
  uvicorn,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "radvel";
  version = "1.6.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "California-Planet-Search";
    repo = "radvel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y99p7aDWB6Ea3BrVHalKDaYHl4J14w9i1pPc+GpTCGo=";
  };

  postPatch =
    # Only pinned to build manylinux2014 wheels
    ''
      substituteInPlace pyproject.toml \
        --replace-fail '"numpy<2.3; python_version < '"'"'3.14'"'"'",' ""
    ''
    # nbsphinx is only needed for building the docs
    + ''
      substituteInPlace radvel/__init__.py \
        --replace-fail "import nbsphinx" ""
    ''
    # Example data is installed in $out, not in the python interpreter's prefix
    + ''
      substituteInPlace radvel/__init__.py \
        --replace-fail \
          "os.path.join(sys.prefix, 'radvel_example_data')" \
          "'$out/radvel_example_data'"
    '';

  build-system = [
    cython
    numpy
    setuptools
  ];

  pythonRemoveDeps = [
    # Only needed at build time
    "cython"
    # Only used for the documentation and the notebook tests
    "ipykernel"
    "ipython"
    "jupyter_client"
    "nbsphinx"
  ];
  dependencies = [
    astropy
    corner
    dill
    emcee
    h5py
    jinja2
    matplotlib
    multiprocess
    numpy
    pandas
    python-dateutil
    scipy
    tables
    ultranest
  ];

  optional-dependencies = {
    api = [
      aiosqlite
      fastapi
      httpx
      pydantic
      pydantic-settings
      python-multipart
      uvicorn
    ]
    ++ uvicorn.optional-dependencies.standard;
  };

  pythonImportsCheck = [ "radvel" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck =
    # Use the compiled extension from the installed package
    ''
      cp $out/${python.sitePackages}/radvel/_kepler*.so radvel/
    ''
    + ''
      export HOME=$(mktemp -d)
      export MPLBACKEND=Agg
      export PATH=$out/bin:$PATH
    '';

  pytestFlags = [
    # Also run the API tests (deselected by default upstream)
    "-o"
    "addopts="
  ];

  disabledTests = [
    # Flaky under load: relies on the worker stopping within a 1s grace period
    # AssertionError: assert 'cancelled by...process group' == 'cancelled by client'
    "test_a_job_submitted_after_a_cancel_still_runs"
  ];

  disabledTestPaths = [
    # Requires nbconvert and the docs notebooks
    "radvel/tests/test_nb.py"
  ];

  meta = {
    description = "General toolkit for modeling radial velocities";
    homepage = "https://github.com/California-Planet-Search/radvel";
    changelog = "https://github.com/California-Planet-Search/radvel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "radvel";
  };
})
