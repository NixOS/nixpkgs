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
  version = "2.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rLLyWbzh/RUIhzR5YJu95bmq5Qg3hHamjWtqGQAufi8=";
  };

  env.PBR_VERSION = version;

  build-system = [
    distro
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
    homepage = "https://docs.opendev.org/opendev/bindep/latest/";
    license = licenses.asl20;
    mainProgram = "bindep";
    maintainers = teams.openstack.members;
  };
}
