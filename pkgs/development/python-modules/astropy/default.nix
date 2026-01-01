{
  lib,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildPythonPackage,
  pythonOlder,

  # build time
  stdenv,
  cython,
  extension-helpers,
  setuptools,
  setuptools-scm,

  # dependencies
  astropy-iers-data,
  numpy,
  packaging,
  pyerfa,
  pyyaml,

  # optional-dependencies
  scipy,
  matplotlib,
  ipython,
  ipywidgets,
  ipykernel,
  pandas,
  certifi,
  dask,
  h5py,
  pyarrow,
  beautifulsoup4,
  html5lib,
  sortedcontainers,
  pytz,
  jplephem,
  mpmath,
  asdf,
  asdf-astropy,
  bottleneck,
  fsspec,
  s3fs,
  uncompresspy,

  # testing
  hypothesis,
  pytestCheckHook,
  pytest-xdist,
  pytest-astropy-header,
  pytest-doctestplus,
  pytest-remotedata,
  threadpoolctl,

}:

buildPythonPackage rec {
  pname = "astropy";
<<<<<<< HEAD
  version = "7.1.1";
=======
  version = "7.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.11";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "astropy";
    repo = "astropy";
    tag = "v${version}";
    hash = "sha256-cvwwTa6eJYncB2V6UCuBrQ5WRRvjgZF5/z4d7Z/uHc8=";
=======
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPJUMiKVsbjPJDA9bxVb9+/bbBKCiCuWbOMEDv+MU8U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=unused-command-line-argument";
  };

  build-system = [
    cython
    extension-helpers
    setuptools
    setuptools-scm
  ];

  dependencies = [
    astropy-iers-data
    numpy
    packaging
    pyerfa
    pyyaml
  ];

  optional-dependencies = lib.fix (self: {
    recommended = [
      scipy
      matplotlib
    ];
    ipython = [
      ipython
    ];
    jupyter = [
      ipywidgets
      ipykernel
      # ipydatagrid
      pandas
    ]
    ++ self.ipython;
    all = [
      certifi
      dask
      h5py
      pyarrow
      beautifulsoup4
      html5lib
      sortedcontainers
      pytz
      jplephem
      mpmath
      asdf
      asdf-astropy
      bottleneck
      fsspec
      s3fs
      uncompresspy
    ]
    ++ self.recommended
    ++ self.ipython
    ++ self.jupyter
    ++ dask.optional-dependencies.array
    ++ fsspec.optional-dependencies.http;
  });

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-xdist
    pytest-astropy-header
    pytest-doctestplus
    pytest-remotedata
    threadpoolctl
    # FIXME remove in 7.2.0
    # see https://github.com/astropy/astropy/pull/18882
    uncompresspy
  ]
  ++ optional-dependencies.recommended;

  pythonImportsCheck = [ "astropy" ];

  __darwinAllowLocalNetworking = true;

  preCheck = ''
    export HOME="$(mktemp -d)"
    export OMP_NUM_THREADS=$(( $NIX_BUILD_CORES / 4 ))
    # See https://github.com/astropy/astropy/issues/17649 and see
    # --hypothesis-profile=ci pytest flag below.
    cp conftest.py $out/
    # https://github.com/NixOS/nixpkgs/issues/255262
    cd "$out"
  '';
  pytestFlags = [
    "--hypothesis-profile=ci"
  ];
  postCheck = ''
    rm conftest.py
  '';

  meta = {
<<<<<<< HEAD
    changelog = "https://docs.astropy.org/en/${src.tag}/changelog.html";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Astronomy/Astrophysics library for Python";
    homepage = "https://www.astropy.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      kentjames
      doronbehar
    ];
  };
}
