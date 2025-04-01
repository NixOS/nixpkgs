{
  lib,
  buildPythonPackage,
  distro,
  fetchPypi,
  packaging,
  parsley,
  pbr,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bindep";
  version = "2.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-33VkdT5YMDO7ETM4FQ13JUAUW00YmkgB7FaiW17eUFA=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    parsley
    pbr
    packaging
    distro
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  pythonImportsCheck = [ "bindep" ];

  meta = with lib; {
    description = "Bindep is a tool for checking the presence of binary packages needed to use an application / library";
    homepage = "https://opendev.org/opendev/bindep";
    license = licenses.asl20;
    mainProgram = "bindep";
    maintainers = teams.openstack.members;
  };
}
