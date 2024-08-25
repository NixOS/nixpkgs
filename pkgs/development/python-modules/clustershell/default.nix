{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  openssh,
  nose,
  bc,
  hostname,
  bash,
}:

buildPythonPackage rec {
  pname = "clustershell";
  version = "1.9.2";

  src = fetchPypi {
    pname = "ClusterShell";
    inherit version;
    hash = "sha256-rsF/HG4GNBC+N49b+sDO2AyUI1G44wJNBUwQNPzShD0=";
  };

  postPatch = ''
    substituteInPlace lib/ClusterShell/Worker/Ssh.py \
      --replace-fail '"ssh"' '"${openssh}/bin/ssh"' \
      --replace-fail '"scp"' '"${openssh}/bin/scp"'

    substituteInPlace lib/ClusterShell/Worker/fastsubprocess.py \
      --replace-fail '"/bin/sh"' '"${bash}/bin/sh"'

    for f in tests/*; do
      substituteInPlace $f \
        --replace-fail '/bin/hostname'   '${hostname}/bin/hostname' \
        --replace-fail '/bin/sleep'      'sleep' \
        --replace-fail '/bin/echo'       'echo' \
        --replace-fail '/bin/uname'      'uname' \
        --replace-fail '/bin/false'      'false' \
        --replace-fail '/bin/true'       'true' \
        --replace-fail '/usr/bin/printf' 'printf'
    done

    # Fix warnings
    substituteInPlace lib/ClusterShell/Task.py \
      --replace-fail "notifyAll" "notify_all"
    substituteInPlace tests/TaskPortTest.py lib/ClusterShell/Task.py \
      --replace-fail "currentThread" "current_thread"
  '';

  propagatedBuildInputs = [ pyyaml ];

  nativeCheckInputs = [
    bc
    hostname
    nose
  ];

  pythonImportsCheck = [ "ClusterShell" ];

  doCheck = false; # tests often get stuck

  # Many tests want to open network connections
  # https://github.com/cea-hpc/clustershell#test-suite
  #
  # Several tests fail on Darwin
  checkPhase = ''
    rm tests/CLIClushTest.py
    rm tests/TreeWorkerTest.py
    rm tests/TaskDistantMixin.py
    rm tests/TaskDistantTest.py
    rm tests/TaskDistantPdshMixin.py
    rm tests/TaskDistantPdshTest.py
    rm tests/TaskRLimitsTest.py
    rm tests/TreeGatewayTest.py

    nosetests -v \
      -e test_fromall_grouplist \
      -e test_rank_placeholder \
      -e test_engine_on_the_fly_launch \
      -e test_ev_pickup_fanout \
      -e test_ev_pickup_fanout_legacy \
      -e test_timeout \
      -e test_008_broken_pipe_on_write \
      -e testLocalBufferRCGathering \
      -e testLocalBuffers \
      -e testLocalErrorBuffers \
      -e testLocalFanout \
      -e testLocalRetcodes \
      -e testLocalRCBufferGathering \
      -e testLocalSingleLineBuffers \
      -e testLocalWorkerFanout \
      -e testSimpleMultipleCommands \
      -e testClushConfigSetRlimit  \
      -e testTimerInvalidateInHandler \
      -e testTimerSetNextFireInHandler \
      -e test_node_placeholder \
    tests/*.py
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Scalable Python framework for cluster administration";
    homepage = "https://cea-hpc.github.io/clustershell";
    license = licenses.lgpl21;
    maintainers = [ maintainers.alexvorobiev ];
  };
}
