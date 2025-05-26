{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
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

buildPythonPackage rec {
  pname = "clustershell";
  version = "1.9.3";
  pyproject = true;

  src = fetchPypi {
    pname = "ClusterShell";
    inherit version;
    hash = "sha256-4oTA5rP+CgzWvmffcd+/aqMhGIlz22g6BX9WN1UvvIw=";
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
      substituteInPlace $f \
        --replace-quiet '/bin/hostname'   '${hostname}/bin/hostname' \
        --replace-quiet '/bin/sleep'      'sleep' \
        --replace-quiet '/bin/echo'       'echo' \
        --replace-quiet '/bin/uname'      'uname' \
        --replace-quiet '/bin/false'      'false' \
        --replace-quiet '/bin/true'       'true' \
        --replace-quiet '/usr/bin/printf' 'printf'
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

  unittestFlagsArray = [
    "tests"
    "-p"
    "'*Test.py'"
  ];

  # Many tests want to open network connections
  # https://github.com/cea-hpc/clustershell#test-suite
  #
  # Several tests fail on Darwin
  preCheck = ''
    rm tests/CLIClushTest.py
    rm tests/TreeWorkerTest.py
    rm tests/TaskDistantMixin.py
    rm tests/TaskDistantTest.py
    rm tests/TaskDistantPdshMixin.py
    rm tests/TaskDistantPdshTest.py
    rm tests/TaskRLimitsTest.py
    rm tests/TreeGatewayTest.py
  '';

  postInstall = ''
    installShellCompletion --bash bash_completion.d/*
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Scalable Python framework for cluster administration";
    homepage = "https://cea-hpc.github.io/clustershell";
    license = licenses.lgpl21;
    maintainers = [ maintainers.alexvorobiev ];
  };
}
