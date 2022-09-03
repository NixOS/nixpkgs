{ lib
, buildPythonApplication
, fetchPypi
, installShellFiles
, mock
, openstacksdk
, pbr
, python-keystoneclient
, pythonOlder
, stestr
}:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O2jHNpnF+8OKzXtvEUPWmSOz+vcQ82XZd6QQS9kni/8=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

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
    installShellCompletion --cmd swift \
      --bash tools/swift.bash_completion
    installManPage doc/manpages/*
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
