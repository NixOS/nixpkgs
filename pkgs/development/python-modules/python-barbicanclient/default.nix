{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitea,
  keystoneauth1,
  openstackdocstheme,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-barbicanclient";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitea {
    domain = "opendev.org";
    owner = "openstack";
    repo = "python-barbicanclient";
    rev = version;
    hash = "sha256-odoYyBulOQkjUpymFyZgvI+DYmdHJY3PaG8hh2ms+/0=";
  };

  env.PBR_VERSION = version;

  postPatch = ''
    # Disable rsvgconverter not needed to build manpage
    substituteInPlace doc/source/conf.py \
      --replace-fail "'sphinxcontrib.rsvgconverter'," "#'sphinxcontrib.rsvgconverter',"
  '';

  build-system = [
    openstackdocstheme
    pbr
    setuptools
    sphinxHook
    sphinxcontrib-apidoc
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    keystoneauth1
    oslo-i18n
    oslo-serialization
    oslo-utils
    requests
  ];

  nativeCheckInputs = [
    requests-mock
    stestr
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "barbicanclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-barbicanclient";
    description = "Client library for OpenStack Barbican API";
    license = lib.licenses.asl20;
    mainProgram = "barbican";
    maintainers = lib.teams.openstack.members;
  };
}
