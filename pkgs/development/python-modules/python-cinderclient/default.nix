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
  pythonOlder,
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
  version = "9.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P+/eJoJS5S4w/idz9lgienjG3uN4/LEy0xyG5uybojg=";
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

  meta = with lib; {
    description = "OpenStack Block Storage API Client Library";
    mainProgram = "cinder";
    homepage = "https://github.com/openstack/python-cinderclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
