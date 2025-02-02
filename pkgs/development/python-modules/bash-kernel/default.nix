{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  ipykernel,
  python,
  pexpect,
  bashInteractive,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "bash-kernel";
  version = "0.9.3";
  pyproject = true;

  src = fetchPypi {
    pname = "bash_kernel";
    inherit version;
    hash = "sha256-n3oDgRyn2csfv/gIIjfPBFC5cYIlL9C4BYeha2XmbVg=";
  };

  patches = [
    (substituteAll {
      src = ./bash-path.patch;
      bash = lib.getExe bashInteractive;
    })
  ];

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    changelog = "https://github.com/takluyver/bash_kernel/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
