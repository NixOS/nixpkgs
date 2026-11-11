{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ddt,
  keystoneauth1,
  openstackdocstheme,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests,
  prettytable,
  reno,
  requests-mock,
  setuptools,
  simplejson,
  sphinxHook,
  stestrCheckHook,
  stevedore,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-cinderclient";
  version = "9.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-cinderclient";
    tag = finalAttrs.version;
    hash = "sha256-TbGDp/N8+Ro5ShSgPfSIA9a0k8Zf2l3E74EWLG1Ko9Q=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    openstackdocstheme
    reno
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include cinderclient *" > MANIFEST.in
  '';

  build-system = [ setuptools ];

  dependencies = [
    simplejson
    keystoneauth1
    oslo-i18n
    oslo-utils
    pbr
    prettytable
    requests
    stevedore
  ];

  nativeCheckInputs = [
    ddt
    oslo-serialization
    requests-mock
    stestrCheckHook
  ];

  pythonImportsCheck = [
    "cinderclient"
    "cinderclient.apiclient"
  ];

  meta = {
    description = "OpenStack Block Storage API Client Library";
    mainProgram = "cinder";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
