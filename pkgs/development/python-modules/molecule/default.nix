{ lib
, buildPythonPackage
, fetchPypi
, testers
, ansible-compat
, ansible-core
, click-help-colors
, enrich
, jsonschema
, molecule
, withPlugins ? true, molecule-plugins
, packaging
, pluggy
, rich
, setuptools
, setuptools-scm
, yamllint
, wcmatch
, wheel
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "24.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g1IrqpuRVg6phic8qxScORVpdunWEkVxciYyCTWtVuQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    ansible-compat
    ansible-core
    click-help-colors
    enrich
    jsonschema
    packaging
    pluggy
    rich
    yamllint
    wcmatch
  ] ++ lib.optional withPlugins molecule-plugins;

  pythonImportsCheck = [ "molecule" ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  passthru.tests.version = (testers.testVersion {
    package = molecule;
    command = "PY_COLORS=0 ${pname} --version";
  }).overrideAttrs (old: {
    # workaround the error: Permission denied: '/homeless-shelter'
    HOME = "$(mktemp -d)";
  });

  meta = with lib; {
    description = "Molecule aids in the development and testing of Ansible roles";
    mainProgram = "molecule";
    homepage = "https://github.com/ansible-community/molecule";
    maintainers = with maintainers; [ dawidd6 ];
    license = licenses.mit;
  };
}
