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
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hj3fmYzL6n3CWqbfjrPffTi/S8lrBl8vhEMeglmBezM=";
  };

  # remove duplicate script that will be created by setuptools from the
  # entry_points section of setup.cfg
  postPatch = ''
    sed -i '/^scripts =/d' setup.cfg
    sed -i '/bin\/swift/d' setup.cfg
  '';

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
