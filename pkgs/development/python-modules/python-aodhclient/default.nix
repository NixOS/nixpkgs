{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  oslotest,
  osprofiler,
  pbr,
  pyparsing,
  setuptools,
  sphinxHook,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-aodhclient";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-aodhclient";
    tag = version;
    hash = "sha256-ymOMCHhntoWr3mROI1M/PN7oWWaDTN58Z9xb97qnP+w=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    osprofiler
    pbr
    pyparsing
  ];

  nativeCheckInputs = [
    oslotest
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "aodhclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-aodhclient";
    description = "Client library for OpenStack Aodh API";
    license = lib.licenses.asl20;
    mainProgram = "aodh";
    teams = [ lib.teams.openstack ];
  };
}
