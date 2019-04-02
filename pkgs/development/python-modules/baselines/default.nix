{ lib
, buildPythonPackage
, fetchPypi
, pytest
, gym
, scipy
, tqdm
, joblib
, dill
, progressbar2
, cloudpickle
, click
, pyzmq
, tensorflow
, mpi4py
}:

buildPythonPackage rec {
  pname = "baselines";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n1mxkcg82gzhkb4j5zzwm335r3rc1sblknqs4x6nkrrh42d65cm";
  };

  patches = [
    # already fixed upstream
    ./fix-dep-names.patch
  ];

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

  # fails to create a daemon, probably because of sandboxing
  doCheck = false;

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "High-quality implementations of reinforcement learning algorithms";
    homepage = https://github.com/openai/baselines;
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
