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
  stestr,
}:

buildPythonPackage rec {
  pname = "python-barbicanclient";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-barbicanclient";
    tag = version;
    hash = "sha256-HhWWUM0lK0B0ySItrT6z5QCXzStuiJzDZFoEb+WRodA=";
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
    teams = [ lib.teams.openstack ];
  };
}
