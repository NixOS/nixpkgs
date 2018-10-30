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
  version = "2.0.0.0b2";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y0yl2w6c9c91f9xbjkvff1ag8p72r24nzparrzrw9sl8kn9632x";
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
