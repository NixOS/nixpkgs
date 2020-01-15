{ stdenv
, buildPythonPackage
, fetchPypi
, pbr
, mock
, python-jenkins
, pyyaml
, six
, stevedore
, isPy27
, fasteners
, jinja2
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "3.0.1";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "16x97pdr90x3xsc1xl66l7q77pgja5dzsk921by2h09k7dvxaqmh";
  };

  postPatch = ''
    export HOME=$TMPDIR
  '';

  propagatedBuildInputs = [ pbr mock python-jenkins pyyaml six stevedore fasteners jinja2 ];

  # Need to fix test deps
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    homepage = "https://docs.openstack.org/infra/system-config/jjb.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
