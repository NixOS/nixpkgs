{
  lib,
  buildPythonPackage,
  distro,
  fetchPypi,
  fixtures,
  libredirect,
  packaging,
  parsley,
  pbr,
  pytestCheckHook,
  testtools,
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
  ];

  dependencies = [
    parsley
    pbr
    packaging
    distro
  ];

  nativeCheckInputs = [
    fixtures
    libredirect.hook
    pytestCheckHook
    testtools
  ];

  preCheck = ''
    echo "ID=nixos
    " > os-release
    export NIX_REDIRECTS=/etc/os-release=$(realpath os-release)
    export PATH=$PATH:$out/bin
  '';

  pytestFlags = [ "-s" ];

  pythonImportsCheck = [ "bindep" ];

  meta = with lib; {
    description = "Bindep is a tool for checking the presence of binary packages needed to use an application / library";
    homepage = "https://opendev.org/opendev/bindep";
    license = licenses.asl20;
    mainProgram = "bindep";
    teams = [ teams.openstack ];
  };
}
