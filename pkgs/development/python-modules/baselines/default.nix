{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  gym,
  scipy,
  tqdm,
  joblib,
  dill,
  progressbar2,
  cloudpickle,
  click,
  pyzmq,
  tensorflow,
  mpi4py,
}:

buildPythonPackage {
  pname = "baselines";
  version = "0.1.6"; # remember to manually adjust the rev
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "baselines";
    # Unfortunately releases are not tagged. This commit bumps the version in setup.py
    rev = "2bca7901f51c88cdef3ca0666c6a87c454a4dbe8";
    sha256 = "0j2ck7rsrcyny9qbmrw9aqvzfhv70nbign8iva2dsisa2x24gbcl";
  };

  propagatedBuildInputs = [
    gym
    scipy
    tqdm
    joblib
    pyzmq
    dill
    progressbar2
    mpi4py
    cloudpickle
    tensorflow
    click
  ];

  postPatch = ''
    # Needed for the atari wrapper, but the gym-atari package is not supported
    # in nixos anyways. Since opencv-python is not currently packaged, we
    # disable it.
    sed -i -e '/opencv-python/d' setup.py
  '';

  # fails to create a daemon, probably because of sandboxing
  doCheck = false;

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "High-quality implementations of reinforcement learning algorithms";
    homepage = "https://github.com/openai/baselines";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
