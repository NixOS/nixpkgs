{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "9.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_cinderclient";
    inherit version;
    hash = "sha256-aX5NEsJJ85tB7PT6b8uMOMvy1rLYTW9RXtVnuC3NC9E=";
  };

  nativeBuildInputs = [
    openstackdocstheme
    reno
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

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
    stestr
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "cinderclient" ];

  meta = {
    description = "OpenStack Block Storage API Client Library";
    mainProgram = "cinder";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
