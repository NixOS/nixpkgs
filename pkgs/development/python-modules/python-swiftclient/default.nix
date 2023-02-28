{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, mock
, openstacksdk
, pbr
, python-keystoneclient
, pythonOlder
, stestr
}:

buildPythonPackage rec {
  pname = "python-swiftclient";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o/Ynzp+1S1fTD9tB3DBb1eYFM+62mueeSWrU7F6EjIU=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    pbr
    python-keystoneclient
  ];

  nativeCheckInputs = [
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
