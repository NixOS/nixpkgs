{
  lib,
  ansible-compat,
  ansible-core,
  buildPythonPackage,
  click-help-colors,
  enrich,
  fetchPypi,
  jsonschema,
  molecule,
  packaging,
  pluggy,
  pythonOlder,
  rich,
  setuptools,
  setuptools-scm,
  testers,
  wcmatch,
  withPlugins ? true,
  molecule-plugins,
  yamllint,
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "25.12.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sia/G+Z84PowxyaqsiYGP5RD5WHX49BI9V37LuUa29Y=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
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
  ]
  ++ lib.optional withPlugins molecule-plugins;

  pythonImportsCheck = [ "molecule" ];

  # tests can't be easily run without installing things from ansible-galaxy
  doCheck = false;

  passthru.tests.version =
    (testers.testVersion {
      package = molecule;
      command = "PY_COLORS=0 ${pname} --version";
    }).overrideAttrs
      (old: {
        # workaround the error: Permission denied: '/homeless-shelter'
        HOME = "$(mktemp -d)";
      });

  meta = with lib; {
    description = "Aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    changelog = "https://github.com/ansible/molecule/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "molecule";
  };
}
