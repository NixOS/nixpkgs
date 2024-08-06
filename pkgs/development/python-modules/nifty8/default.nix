{
  buildPythonPackage,
  mpiCheckPhaseHook,
  config,
  fetchFromGitLab,
  lib,
  pytestCheckHook,
  setuptools,

  cudaSupport ? config.cudaSupport,

  astropy,
  ducc0,
  h5py,
  jax,
  jaxlib,
  matplotlib,
  mpi,
  mpi4py,
  numpy,
  openssh,
  scipy,
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
    numpy
    mpi4py
    mpi
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
    ${mpi}/bin/mpiexec -n 2 --bind-to none python3 -m pytest test/test_mpi

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
