{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, tensorflow
, annoy
, pillow
, matplotlib
, numpy
, pandas
, pygame
, pyopengl
, scipy
, scikitimage
, gym
, bokeh
, kubernetes
, redis
, minio
, pytest
, psutil
}:

buildPythonPackage rec {
  version = "1.0.1";
  pname = "rl-coach";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c4f3a334ff55d534d2fc7f83d5e791f64b780391039e367f6cd9b4381838744";
  };

  propagatedBuildInputs = [
    tensorflow
    annoy
    pillow
    matplotlib
    numpy
    pandas
    pygame
    pyopengl
    scipy
    scikitimage
    gym
    bokeh
    kubernetes
    redis
    minio
    psutil
  ];

  checkInputs = [
    pytest
  ];

  # run only some tests that do not need any optional dependencies
  # available tests: https://github.com/NervanaSystems/coach/tree/master/rl_coach/tests
  testsToRun = [
    # test only the tensorflow backend (not mxnet)
    "architectures/tensorflow_components"
    "agents"
    "exploration_policies"
    "filters"
    "memories"
    "utils"
  ];
  checkPhase = let
    fullTestPaths = map (testfile: "rl_coach/tests/${testfile}") testsToRun;
    escapedPaths = map lib.escapeShellArg fullTestPaths;
    pytestArgs = builtins.concatStringsSep " " escapedPaths;
  in
  ''
    pytest ${pytestArgs}
  '';

  postPatch = ''
    # pinned to 8.0.1 for unknown reason, at least basic functionallity seems to work without it
    # https://github.com/NervanaSystems/coach/pull/149#issuecomment-495915804
    sed -i '/kubernetes/d' requirements.txt

    # this is just an "intel-optimized" version of tensorflow, e.g. an implementation detail
    sed -i 's/intel-tensorflow/tensorflow/g' setup.py

    # backports of python3 features not needed
    # https://github.com/NervanaSystems/coach/issues/324
    sed -i '/futures/d' requirements.txt
  '';

  disabled = pythonOlder "3.5"; # minimum required version

  meta = with stdenv.lib; {
    description = "Enables easy experimentation with state of the art Reinforcement Learning algorithms";
    homepage = "https://nervanasystems.github.io/coach/";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
