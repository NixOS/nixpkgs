{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  filetype,
  ipykernel,
  python,
  pexpect,
  bashInteractive,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "bash-kernel";
  version = "0.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "bash_kernel";
    inherit version;
    hash = "sha256-LtWgpBbEGNHXUecVBb1siJ4SFXREtQxCh6aF2ndcKMo=";
  };

  patches = [
    (substituteAll {
      src = ./bash-path.patch;
      bash = lib.getExe bashInteractive;
    })
  ];

  build-system = [ flit-core ];

  dependencies = [
    filetype
    ipykernel
    pexpect
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    ${python.pythonOnBuildForHost.interpreter} -m bash_kernel.install --prefix $out
  '';

  checkPhase = ''
    runHook preCheck

    # Create a JUPYTER_PATH with the kernelspec
    export JUPYTER_PATH=$(mktemp -d)
    mkdir -p $JUPYTER_PATH/kernels/bash
    echo '{ "language": "bash", "argv": [ "${python}/bin/python", "-m", "bash_kernel", "-f", "{connection_file}" ] }' > $JUPYTER_PATH/kernels/bash/kernel.json

    # Evaluate a test notebook with papermill
    cd $(mktemp -d)
    ${python.withPackages (ps: [ ps.papermill ])}/bin/papermill --kernel bash ${./test.ipynb} out.ipynb

    runHook postCheck
  '';

  meta = {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    changelog = "https://github.com/takluyver/bash_kernel/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
