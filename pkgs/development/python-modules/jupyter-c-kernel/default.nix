{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipykernel,
  gcc,
}:

buildPythonPackage rec {
  pname = "jupyter-c-kernel";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "jupyter_c_kernel";
    inherit version;
    hash = "sha256-5LNCNbQnYc/D/wg4ZnWyNi5al/uSbBNe7ngmYdsIoUA=";
  };

  postPatch = ''
    substituteInPlace jupyter_c_kernel/kernel.py \
      --replace "'gcc'" "'${gcc}/bin/gcc'"
  '';

  propagatedBuildInputs = [ ipykernel ];

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
