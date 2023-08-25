{ lib
, buildPythonPackage
, fetchPypi
, ansible-compat
, ansible-core
, click-help-colors
, cookiecutter
, enrich
, jsonschema
, withPlugins ? true, molecule-plugins
, packaging
, pluggy
, rich
, setuptools
, yamllint
}:

buildPythonPackage rec {
  pname = "molecule";
  version = "5.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+nr4n9+TF1OcPsqZyx5edSLXpX4LZ/W2mORCdvmNnYI=";
  };

  propagatedBuildInputs = [
    ansible-compat
    ansible-core
    click-help-colors
    cookiecutter
    enrich
    jsonschema
    packaging
    pluggy
    rich
    yamllint
  ] ++ lib.optional withPlugins molecule-plugins;

  nativeBuildInputs = [
    setuptools
  ];

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
