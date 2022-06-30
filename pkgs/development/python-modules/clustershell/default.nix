{ stdenv, lib, buildPythonPackage, fetchPypi, pyyaml, openssh
, nose, bc, hostname, coreutils, bash, gnused
}:

buildPythonPackage rec {
  pname = "ClusterShell";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff6fba688a06e5e577315d899f0dab3f4fe479cef99d444a4e651af577b7d081";
  };

  propagatedBuildInputs = [ pyyaml ];

  postPatch = ''
    substituteInPlace lib/ClusterShell/Worker/Ssh.py \
      --replace '"ssh"' '"${openssh}/bin/ssh"' \
      --replace '"scp"' '"${openssh}/bin/scp"'

    substituteInPlace lib/ClusterShell/Worker/fastsubprocess.py \
      --replace '"/bin/sh"' '"${bash}/bin/sh"'
  '';

  checkInputs = [ nose bc hostname coreutils gnused ];

  # Many tests want to open network connections
  # https://github.com/cea-hpc/clustershell#test-suite
  #
  # Several tests fail on Darwin
  checkPhase = ''
    for f in tests/*; do
      substituteInPlace $f \
        --replace '/bin/hostname'   '${hostname}/bin/hostname' \
        --replace '/bin/sleep'      '${coreutils}/bin/sleep' \
        --replace '"sleep'          '"${coreutils}/bin/sleep' \
        --replace '/bin/echo'       '${coreutils}/bin/echo' \
        --replace '/bin/uname'      '${coreutils}/bin/uname' \
        --replace '/bin/false'      '${coreutils}/bin/false' \
        --replace '/bin/true'       '${coreutils}/bin/true' \
        --replace '/usr/bin/printf' '${coreutils}/bin/printf' \
        --replace '"sed'            '"${gnused}/bin/sed' \
        --replace ' sed '           ' ${gnused}/bin/sed '
    done

    rm tests/CLIClushTest.py
    rm tests/TreeWorkerTest.py
    rm tests/TaskDistantMixin.py
    rm tests/TaskDistantTest.py
    rm tests/TaskDistantPdshMixin.py
    rm tests/TaskDistantPdshTest.py
    rm tests/TaskRLimitsTest.py

    nosetests -v \
      -e test_channel_ctl_shell_remote1 \
      -e test_channel_ctl_shell_remote2 \
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
      -e test_channel_ctl_shell_mlocal1 \
      -e test_channel_ctl_shell_mlocal2 \
      -e test_channel_ctl_shell_mlocal3 \
      -e test_node_placeholder \
    tests/*.py
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Scalable Python framework for cluster administration";
    homepage = "https://cea-hpc.github.io/clustershell";
    license = licenses.lgpl21;
    maintainers = [ maintainers.alexvorobiev ];
  };
}
