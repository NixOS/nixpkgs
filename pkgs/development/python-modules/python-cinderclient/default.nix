{
  lib,
  buildPythonPackage,
  fetchPypi,
  ddt,
  keystoneauth1,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  requests,
  prettytable,
  requests-mock,
  simplejson,
  stestr,
  stevedore,
}:

buildPythonPackage rec {
  pname = "python-cinderclient";
  version = "9.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G51xev+TytQgBF+2xS9jdqty8IX4GTEwiSAg7EbJNVU=";
  };

  propagatedBuildInputs = [
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
    stestr run
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
