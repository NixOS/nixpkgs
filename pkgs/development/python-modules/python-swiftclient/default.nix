{ lib
, buildPythonApplication
, fetchPypi
, mock
, openstacksdk
, pbr
, python-keystoneclient
, pythonOlder
, stestr
}:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V7bx/yO0ZoQ4AqaBb0trvGiWtq0F1ld6/udiK+OilTg=";
  };

  propagatedBuildInputs = [
    pbr
    python-keystoneclient
  ];

  checkInputs = [
    mock
    openstacksdk
    stestr
  ];

  postInstall = ''
    install -Dm644 tools/swift.bash_completion $out/share/bash_completion.d/swift
  '';

  checkPhase = ''
    stestr run
  '';

  pythonImportsCheck = [
    "swiftclient"
  ];

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
