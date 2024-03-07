{ lib
, buildPythonPackage
, fetchPypi
, ansible-compat
, ansible-core
, click-help-colors
, enrich
, jsonschema
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
  version = "6.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0qiBBi/MXvHgjB5RJ8BDVNLJUXGVXicL2Cs/v+9y07A=";
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

  meta = with lib; {
    description = "Molecule aids in the development and testing of Ansible roles";
    homepage = "https://github.com/ansible-community/molecule";
    maintainers = with maintainers; [ dawidd6 ];
    license = licenses.mit;
  };
}
