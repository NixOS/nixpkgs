{
  lib,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  ipykernel,
  gcc,
}:

buildPythonPackage rec {
  pname = "jupyter-c-kernel";
  version = "1.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_c_kernel";
    inherit version;
    sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
  };

  postPatch = ''
    substituteInPlace jupyter_c_kernel/kernel.py \
      --replace-fail "'gcc'" "'${gcc}/bin/gcc'"
  '';

  build-system = [ setuptools ];

  dependencies = [ ipykernel ];

  # no tests in repository
  doCheck = false;

  meta = with lib; {
    description = "Minimalistic C kernel for Jupyter";
    mainProgram = "install_c_kernel";
    homepage = "https://github.com/brendanrius/jupyter-c-kernel/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
