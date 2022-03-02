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
  version = "3.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LSbJC2OS9r76f7sW/Np75Eqibiropb7icF0dHIE4M/A=";
  };

  propagatedBuildInputs = [ pbr python-keystoneclient ];

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

  pythonImportsCheck = [ "swiftclient" ];

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
