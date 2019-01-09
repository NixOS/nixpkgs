{ stdenv
, buildPythonPackage
, fetchPypi
, pip
, pbr
, mock
, python-jenkins
, pyyaml
, six
, stevedore
, isPy27
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "2.6.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1768b278efa8825d2549c03de6ef1d2458e741b9b7984d94db0ef3c22e608938";
  };

  patchPhase = ''
    export HOME=$TMPDIR
  '';

  buildInputs = [ pip ];
  propagatedBuildInputs = [ pbr mock python-jenkins pyyaml six stevedore ];

  meta = with stdenv.lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    homepage = "https://docs.openstack.org/infra/system-config/jjb.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ garbas ];
  };

}
