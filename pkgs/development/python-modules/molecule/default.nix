{ lib, buildPythonPackage, fetchPypi, pkgs,
setuptools, setuptools-scm, setuptools-scm-git-archive, wheel,
ansible-compat,
click-help-colors,
cookiecutter,
enrich,
jsonschema,
packaging,
pluggy,
pyyaml,
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EzYvdBocgCeaKyX0mh9Vw7/DRQVMX+7c3N+SjhED4eU=";
  };

  meta = with lib; {
    description = "A test framework for Ansible.";
    homepage = "https://github.com/ansible-community/molecule";
    license = licenses.mit;
    maintainers = [ maintainers.greg ];
  };

  doCheck = false;

  # Gets pulled into running environments as well
  propagatedBuildInputs = [
    ansible-compat
    click-help-colors
    cookiecutter
    enrich
    jsonschema
    packaging
    pluggy
    pyyaml
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
