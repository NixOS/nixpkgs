{ lib
, python3Packages
, podman
, fetchPypi
}:
python3Packages.buildPythonPackage rec {
  pname = "ansible-builder";
  version = "3.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rxyhgj9Cad751tPAptCTLCtXQLUXaRYv39bkoFzzjOk=";
  };

  buildInputs = with python3Packages; [
    setuptools
    setuptools-scm
    bindep
  ];

  propagatedBuildInputs = with python3Packages; [
    podman
    jsonschema
    requirements-parser
    pyyaml
  ];

  patchPhase = ''
    # the upper limits of setuptools are unnecessary
    sed -i 's/, <=[0-9.]*//g' pyproject.toml
  '';

  meta = with lib; {
    description = "An Ansible execution environment builder";
    homepage = "https://ansible-builder.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ melkor333 ];
  };
}
