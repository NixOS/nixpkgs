{
  lib,
  buildPythonPackage,
  cliff,
  fetchFromGitHub,
  keystoneauth1,
  openstackdocstheme,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests-mock,
  requests,
  setuptools,
  sphinxcontrib-apidoc,
  sphinxHook,
  stestrCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-barbicanclient";
  version = "7.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-barbicanclient";
    tag = finalAttrs.version;
    hash = "sha256-hRzzByFJxYbFxGtP/0/Rko/zgGtgXzyIS6dny+ZaTMQ=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

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
    stestrCheckHook
  ];

  pythonImportsCheck = [ "barbicanclient" ];

  meta = {
    homepage = "https://opendev.org/openstack/python-barbicanclient";
    description = "Client library for OpenStack Barbican API";
    license = lib.licenses.asl20;
    mainProgram = "barbican";
    teams = [ lib.teams.openstack ];
  };
})
