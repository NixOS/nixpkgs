{ lib, buildPythonPackage, fetchPypi, pkgs,
setuptools, setuptools-scm, setuptools-scm-git-archive, wheel,
molecule,
selinux-python,
}:

buildPythonPackage rec {
  pname = "molecule-podman";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zqLqysVPEpgkUw01Rp3de/8QmpTrzYQIgor4wNq/XHo=";
  };

  meta = with lib; {
    description = "A plugin for Molecule allowing Podman resources";
    homepage = "https://github.com/ansible-community/molecule-podman";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };

  doCheck = false;

  # Gets pulled into running environments as well
  propagatedBuildInputs = [
    molecule
    selinux-python
  ];

  format = "pyproject";  # For when it has only pyproject.toml
  # Only needed at the buid stage
  buildInputs = [
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
    wheel
  ];
}
