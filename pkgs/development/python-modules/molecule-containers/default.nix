{ lib, buildPythonPackage, fetchPypi, pkgs,
setuptools, setuptools-scm, setuptools-scm-git-archive, wheel,
molecule,
molecule-docker,
molecule-podman,
}:

buildPythonPackage rec {
  pname = "molecule-containers";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yD90kAFyhhT5cnhIdVhamaR8vIT7jjfwUkRmDqfUx5w=";
  };

  meta = with lib; {
    description = "A pluin for Molecule to run in Podman/Docker containers";
    homepage = "https://github.com/ansible-community/molecule-containers";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };

  doCheck = false;

  # Gets pulled into running environments as well
  propagatedBuildInputs = [
    molecule
    molecule-docker
    molecule-podman
  ];

  format = "pyproject";
  # Only needed at the buid stage
  buildInputs = [
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
    wheel
  ];
}
