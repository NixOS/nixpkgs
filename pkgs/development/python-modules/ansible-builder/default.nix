{
  lib,
  setuptools,
  setuptools-scm,
  jsonschema,
  requirements-parser,
  pyyaml,
  podman,
  fetchPypi,
  bindep,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "ansible-builder";
  version = "3.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rxyhgj9Cad751tPAptCTLCtXQLUXaRYv39bkoFzzjOk=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ bindep ];

  propagatedBuildInputs = [
    podman
    jsonschema
    requirements-parser
    pyyaml
  ];

  patchPhase = ''
    # the upper limits of setuptools are unnecessary
    # See https://github.com/ansible/ansible-builder/issues/639
    sed -i 's/, <=[0-9.]*//g' pyproject.toml
  '';

  meta = with lib; {
    description = "Ansible execution environment builder";
    homepage = "https://ansible-builder.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
