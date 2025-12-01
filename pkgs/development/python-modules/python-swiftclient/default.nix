{
  lib,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  mock,
  openstacksdk,
  pbr,
  python-keystoneclient,
  pythonOlder,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-swiftclient";
  version = "4.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_swiftclient";
    inherit version;
    hash = "sha256-niB7guwxeG8Q24/vbiBWgcJJl6C2ANKKGU+dFakO13I=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = [
    pbr
  ];

  dependencies = [
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

  pythonImportsCheck = [ "swiftclient" ];

  meta = with lib; {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    mainProgram = "swift";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
