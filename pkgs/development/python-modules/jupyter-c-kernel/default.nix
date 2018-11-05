{ stdenv
, buildPythonPackage
, fetchPypi
, writeText
, python
, isPy27
}:

let kernelSpecFile = writeText "kernel.json" (builtins.toJSON {
       argv = [ "${python.interpreter}" "-m" "jupyter_c_kernel" "-f" "{connection_file}" ];
       display_name = "C";
       language = "c";
    });
in
buildPythonPackage rec {
  pname = "jupyter_c_kernel";
  version = "1.2.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
  };

  # install kernel manually
  postInstall = ''
    mkdir -p $out/share/jupyter/kernels/C/
    ln -s ${kernelSpecFile} $out/share/jupyter/kernels/C/kernel.json
  '';

  # no tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Minimalistic C kernel for Jupyter";
    homepage = https://github.com/brendanrius/jupyter-c-kernel/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
