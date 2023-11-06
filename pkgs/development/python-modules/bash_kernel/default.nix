{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, flit-core
, ipykernel
, isPy27
, python
, pexpect
, bash
}:

buildPythonPackage rec {
  pname = "bash_kernel";
  version = "0.9.1";
  format = "flit";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AYPVPjYP+baEcQUqmiiagWIXMlFrA04njpcgtdFaFis=";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/takluyver/bash_kernel/pull/69.diff";
      sha256 = "1qd7qjjmcph4dk6j0bl31h2fdmfiyyazvrc9xqqj8y21ki2sl33j";
    })
  ];

  postPatch = ''
    substituteInPlace bash_kernel/kernel.py \
      --replace "'bash'" "'${bash}/bin/bash'" \
      --replace "\"bash\"" "'${bash}/bin/bash'"
  '';

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ ipykernel pexpect ];

  # no tests
  doCheck = false;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    ${python.pythonOnBuildForHost.interpreter} -m bash_kernel.install --prefix $out
  '';

  meta = with lib; {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    changelog = "https://github.com/takluyver/bash_kernel/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
