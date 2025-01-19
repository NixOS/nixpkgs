{
  lib,
  buildPythonPackage,
  fetchPypi,
  dulwich,
  pbr,
  sphinx,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openstackdocstheme";
  version = "3.4.1";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OPT2rGO967RlJ17iEm5oMuaxqZ8Y8ya+gKMzU0qaGzk=";
  };

  postPatch = ''
    patchShebangs bin/
  '';

  build-system = [ setuptools ];

  dependencies = [
    dulwich
    pbr
    sphinx
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "openstackdocstheme" ];

  meta = {
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    homepage = "https://github.com/openstack/openstackdocstheme";
    license = lib.licenses.asl20;
    maintainers = lib.teams.openstack.members;
  };
}
