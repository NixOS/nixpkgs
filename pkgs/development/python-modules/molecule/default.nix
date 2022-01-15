{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, ansible-lint
, ansible-compat
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
  version = "3.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jp0djj69w0vw2697yr471zdkvd4smggcfvan5z8v6f0wncz0an8";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace 'PyYAML >= 5.1, < 6' 'PyYAML' \
      --replace 'cerberus >= 1.3.1, !=1.3.3, !=1.3.4' 'cerberus'
  '';

  propagatedBuildInputs = [
    ansible-lint
    ansible-compat
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

  meta = with lib; {
    description = "Molecule aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    maintainers = with maintainers; [ ilpianista ];
    license = licenses.mit;
  };
}
