{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flit-core
, ipykernel
, python
, pexpect
, bash
, substituteAll
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
      bash = lib.getExe bash;
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

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

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    changelog = "https://github.com/takluyver/bash_kernel/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
