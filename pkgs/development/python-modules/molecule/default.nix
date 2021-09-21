{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, ansible-lint
, cerberus
, click
, click-help-colors
, click-completion
, cookiecutter
, pluggy
, pyyaml
, selinux-python
, subprocess-tee
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ac0fde11f895bbc6727de26e2ab0bd0316964f4e4facfd821240959814f9572";
  };

  propagatedBuildInputs = [
    ansible-lint
    cerberus
    click
    click-completion
    click-help-colors
    cookiecutter
    pluggy
    pyyaml
    selinux-python
    subprocess-tee
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "molecule" ];

  meta = {
    description = "Molecule aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    maintainers = with lib.maintainers; [ ilpianista ];
    license = lib.licenses.mit;
  };
}
