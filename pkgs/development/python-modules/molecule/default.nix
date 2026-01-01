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
<<<<<<< HEAD
  version = "25.12.0";
=======
  version = "25.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-sia/G+Z84PowxyaqsiYGP5RD5WHX49BI9V37LuUa29Y=";
=======
    hash = "sha256-xliI4yg8JncEj5RdGXKWBk/87orqW7fo//ObHBmc47o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    changelog = "https://github.com/ansible/molecule/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
=======
  meta = with lib; {
    description = "Aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    changelog = "https://github.com/ansible/molecule/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dawidd6 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "molecule";
  };
}
