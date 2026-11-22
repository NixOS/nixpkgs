{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  distutils,
  pyyaml,
  openssh,
  unittestCheckHook,
  installShellFiles,
  bc,
  hostname,
  bash,
}:

buildPythonPackage (finalAttrs: {
  pname = "clustershell";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clustershell";
    repo = "clustershell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ePHMyQNO2wig5rolPSQlezcrOJG4ehoRqZG1079EdVM=";
  };

  build-system = [
    setuptools
    distutils
  ];

  postPatch = ''
    substituteInPlace lib/ClusterShell/Worker/Ssh.py \
      --replace-fail '"ssh"' '"${openssh}/bin/ssh"' \
      --replace-fail '"scp"' '"${openssh}/bin/scp"'

    substituteInPlace lib/ClusterShell/Worker/fastsubprocess.py \
      --replace-fail '"/bin/sh"' '"${bash}/bin/sh"'

    for f in tests/*; do
      if [ -f $f ]; then
        substituteInPlace $f \
          --replace-quiet '/bin/hostname'   '${hostname}/bin/hostname' \
          --replace-quiet '/bin/sleep'      'sleep' \
          --replace-quiet '/bin/echo'       'echo' \
          --replace-quiet '/bin/uname'      'uname' \
          --replace-quiet '/bin/false'      'false' \
          --replace-quiet '/bin/true'       'true' \
          --replace-quiet '/usr/bin/printf' 'printf'
      fi
    done
  '';

  propagatedBuildInputs = [ pyyaml ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [
    bc
    hostname
    unittestCheckHook
  ];

  pythonImportsCheck = [ "ClusterShell" ];

  unittestFlags = [
    "--start-directory=tests"
    "--pattern=*Test.py"
  ];

  # Many tests want to open network connections
  # https://github.com/cea-hpc/clustershell#test-suite
  #
  # Several tests fail on Darwin
  #
  # Lots of them want to import from none exting `.TLib`
  preCheck = ''
    rm tests/CLIClushTest.py
    rm tests/TreeWorkerTest.py
    rm tests/TaskDistantMixin.py
    rm tests/TaskDistantTest.py
    rm tests/TaskDistantPdshMixin.py
    rm tests/TaskDistantPdshTest.py
    rm tests/TaskRLimitsTest.py
    rm tests/TreeGatewayTest.py
    rm tests/WorkerExecTest.py
    rm tests/TreeTopologyTest.py
    rm tests/TreeTaskTest.py
    rm tests/TaskTimerTest.py
    rm tests/TaskLocalTest.py
    rm tests/NodeSetGroupTest.py
    rm tests/MisusageTest.py
    rm tests/DefaultsTest.py
    rm tests/CLINodesetTest.py
    rm tests/CLIConfigTest.py
    rm tests/CLIClubakTest.py
  '';

  postInstall = ''
    installShellCompletion --bash bash_completion.d/*
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Scalable Python framework for cluster administration";
    homepage = "https://cea-hpc.github.io/clustershell";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.alexvorobiev ];
  };
})
