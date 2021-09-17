{ lib
, buildPythonApplication
, fetchPypi
, mock
, openstacksdk
, pbr
, python-keystoneclient
, stestr
}:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MTtEShTQ+bYoy/PoxS8sQnFlj56KM9QiKFHC5PD3t6A=";
  };

  propagatedBuildInputs = [ pbr python-keystoneclient ];

  checkInputs = [
    mock
    openstacksdk
    stestr
  ];

  checkPhase = ''
    stestr run
  '';

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
