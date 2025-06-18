{
  lib,
  setuptools,
  setuptools-scm,
  jsonschema,
  pyyaml,
  podman,
  fetchPypi,
  bindep,
  buildPythonPackage,
  packaging,
}:

buildPythonPackage rec {
  pname = "ansible-builder";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ansible_builder";
    inherit version;
    hash = "sha256-0txXPianvVCV6YrrN+6bALyfUAWr6nFH10IpwPNCb8s=";
  };

  patchPhase = ''
    # the upper limits of setuptools are unnecessary
    # See https://github.com/ansible/ansible-builder/issues/639
    sed -i 's/, <=[0-9.]*//g' pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    podman
    bindep
    jsonschema
    pyyaml
    packaging
  ];

  meta = with lib; {
    description = "Ansible execution environment builder";
    homepage = "https://ansible-builder.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
