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
  pythonOlder,
  setuptools,
  sphinxHook,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-aodhclient";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-aodhclient";
    rev = "refs/tags/${version}";
    hash = "sha256-FArXBkDOY0Weu3Fm/M0Qgg0XHTy95MqlUidZ/hUZfB8=";
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
    homepage = "https://opendev.org/openstack/python-aodhclient";
    description = "Client library for OpenStack Aodh API";
    license = lib.licenses.asl20;
    mainProgram = "aodh";
    maintainers = lib.teams.openstack.members;
  };
}
