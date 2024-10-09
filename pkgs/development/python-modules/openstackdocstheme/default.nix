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
  version = "3.3.0";
  pyproject = true;

  # breaks on import due to distutils import through pbr.packaging
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wmZJmX5bQKM1uwqWxynkY5jPJaBn+Y2eqSRkE2Ub0qM=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
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
