{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, ipykernel
, isPy27
, python
, pexpect
, bash
}:

buildPythonPackage rec {
  pname = "bash_kernel";
  version = "0.7.1";
  format = "flit";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2kc7m52kq28b4j1q3456g5ani6nmq4n0rpbqi3yvh7ks0rby19";
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

  propagatedBuildInputs = [ ipykernel pexpect ];

  # no tests
  doCheck = false;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    ${python.interpreter} -m bash_kernel.install --prefix $out
  '';

  meta = {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
