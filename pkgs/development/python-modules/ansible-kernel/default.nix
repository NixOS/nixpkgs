{ lib
, buildPythonPackage
, fetchPypi
, writeText
, ipywidgets
, six
, docopt
, tqdm
, jupyter
, psutil
, pyyaml
, ansible-runner
, ansible
, python
}:

let
  kernelSpecFile = writeText "kernel.json" (builtins.toJSON {
    argv = [ python.interpreter "-m" "ansible_kernel" "-f" "{connection_file}" ];
    codemirror_mode = "yaml";
    display_name = "Ansible";
    language = "ansible";
  });
in
buildPythonPackage rec {
  pname = "ansible-kernel";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a59039a1724c0f4f4435316e2ad3383f2328ae61f190e74414a66cc8c4637636";
  };

  propagatedBuildInputs = [ ipywidgets six docopt tqdm jupyter psutil pyyaml ansible-runner ansible ];

  postPatch = ''
   # remove when merged
   # https://github.com/ansible/ansible-jupyter-kernel/pull/82
   touch LICENSE.md

   # remove custom install
   sed -i "s/cmdclass={'install': Installer},//" setup.py
  '';

  # tests hang with launched kernel
  doCheck = false;

  # install kernel manually
  postInstall = ''
    mkdir -p $out/share/jupyter/kernels/ansible/
    ln -s ${kernelSpecFile} $out/share/jupyter/kernels/ansible/kernel.json
  '';

  meta = with lib; {
    description = "An Ansible kernel for Jupyter";
    homepage = "https://github.com/ansible/ansible-jupyter-kernel";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
