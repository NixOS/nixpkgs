{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,

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
  version = "8.5.4";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "ift";
    repo = "nifty";
    tag = "v${version}";
    hash = "sha256-Q42ZhQ/T8JmkG75BexevbvVKQqfDmMG6+oTYR0Ze718=";
  };

  build-system = [ setuptools ];

  dependencies = [
    astropy
    ducc0
    h5py
    jax
    jaxlib
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
    changelog = "https://gitlab.mpcdf.mpg.de/ift/nifty/-/blob/${src.tag}/ChangeLog.md";
    description = "Bayesian Imaging library for high-dimensional posteriors";
    longDescription = ''
      NIFTy, "Numerical Information Field Theory", is a Bayesian imaging library.
      It is designed to infer the million to billion dimensional posterior
      distribution in the image space from noisy input data.  At the core of
      NIFTy lies a set of powerful Gaussian Process (GP) models and accurate
      Variational Inference (VI) algorithms.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ parras ];
  };
}
