{ lib, buildPythonApplication, fetchPypi
, requests, six, pbr
}:

buildPythonApplication rec {
  pname = "python-swiftclient";
  version = "3.12.0";

  src = fetchPypi {
    pname = "python-swiftclient";
    inherit version;
    sha256 = "313b444a14d0f9b628cbf3e8c52f2c4271658f9e8a33d4222851c2e4f0f7b7a0";
  };

  propagatedBuildInputs = [
    pbr
    requests
    six
  ];

  checkPhase = ''
    runHook preCheck
    $out/bin/swift --version | grep ${version} > /dev/null
    runHook postCheck
  '';

  pythonImportsCheck = [ "swiftclient" ];

  meta = with lib; {
    description = "A python client for the Swift API, includes a Python API module (swiftclient) and a CLI application (swift). ";
    downloadPage = "https://github.com/openstack/python-swiftclient";
    homepage = "https://docs.openstack.org/python-swiftclient/";
    license = licenses.asl20;
    maintainers = with maintainers; [ superherointj ];
  };
}
