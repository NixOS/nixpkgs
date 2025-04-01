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
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r9dXV1PY5JYXrcsRVQGH/QsSD82Bnx54LAtTjy0JN3M=";
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
    maintainers = teams.openstack.members;
  };
}
