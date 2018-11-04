{ stdenv
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

let kernelSpecFile = writeText "kernel.json" (builtins.toJSON {
       argv = [ "${python.interpreter}" "-m" "ansible_kernel" "-f" "{connection_file}" ];
       codemirror_mode = "yaml";
       display_name = "Ansible";
       language = "ansible";
    });
in
buildPythonPackage rec {
  pname = "ansible-kernel";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e63a5225327f8670c379871cf67154f953bf0d17d35c064dde159f4eeda7f466";
  };

  propagatedBuildInputs = [ ipywidgets six docopt tqdm jupyter psutil pyyaml ansible-runner ansible ];

  postPatch = ''
   touch LICENSE.md

   # remove custom install
   sed -i "s/cmdclass={'install': Installer},//" setup.py
  '';

  # install kernel manually
  postInstall = ''
    mkdir -p $out/share/jupyter/kernels/ansible/
    ln -s ${kernelSpecFile} $out/share/jupyter/kernels/ansible/kernel.json
  '';

  meta = with stdenv.lib; {
    description = "An Ansible kernel for Jupyter";
    homepage = https://github.com/ansible/ansible-jupyter-kernel;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
