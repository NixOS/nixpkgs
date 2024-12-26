{
  config,
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

  cudaSupport ? config.cudaSupport,

  # build-system
  setuptools,

  # dependencies
  astropy,
  ducc0,
  h5py,
  jax,
  jaxlib,
  matplotlib,
  mpi,
  mpi4py,
  numpy,
  scipy,

  # test
  pytestCheckHook,
  mpiCheckPhaseHook,
  openssh,
}:

buildPythonPackage rec {
  pname = "nifty8";
  version = "8.5.2";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "ift";
    repo = "nifty";
    rev = "v${version}";
    hash = "sha256-EWsJX+iqKOhQXEWlQfYUiPYqyfOfrwLtbI+DVn7vCQI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    astropy
    ducc0
    h5py
    jax
    (jaxlib.override { inherit cudaSupport; })
    matplotlib
    mpi4py
    mpi
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mpiCheckPhaseHook
    openssh
  ];

  checkPhase = ''
    runHook preCheck

    python3 -m pytest test

    if [ "${stdenv.buildPlatform.system}" != "aarch64-linux" ] && \
       [ "${stdenv.buildPlatform.system}" != "x86_64-darwin" ]; then
    ${mpi}/bin/mpiexec -n 2 --bind-to none python3 -m pytest test/test_mpi
    fi

    runHook postCheck
  '';

  pythonImportsCheck = [ "nifty8" ];

  meta = {
    homepage = "https://gitlab.mpcdf.mpg.de/ift/nifty";
    description = "Bayesian Imaging library for high-dimensional posteriors";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ parras ];
  };
}
