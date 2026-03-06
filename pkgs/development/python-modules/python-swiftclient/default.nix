{
  lib,
  buildPythonPackage,
  fetchPypi,
  installShellFiles,
  mock,
  openstacksdk,
  pbr,
  python-keystoneclient,
  stestr,
}:

buildPythonPackage rec {
  pname = "python-swiftclient";
  version = "4.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_swiftclient";
    inherit version;
    hash = "sha256-mBiRq8f7NVsmboI98+y4DlwmfFeTT7UJS7EC3a9+Ub4=";
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

  meta = {
    homepage = "https://github.com/openstack/python-swiftclient";
    description = "Python bindings to the OpenStack Object Storage API";
    mainProgram = "swift";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
