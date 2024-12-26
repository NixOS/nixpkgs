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
  version = "3.4.0";
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YA3nY7Q6UM9sviGRUh08EwwLEjneO2KAh4Hsr/hn25U=";
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

  meta = with lib; {
    description = "Sphinx theme for RST-sourced documentation published to docs.openstack.org";
    homepage = "https://github.com/openstack/openstackdocstheme";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
