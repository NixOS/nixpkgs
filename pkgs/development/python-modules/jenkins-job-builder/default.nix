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
, fasteners
, jinja2
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "2.10.0";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cca981c5b97970394820bd53a3b2a408003c4993241f4f04385b423f14d8e84a";
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
    maintainers = with maintainers; [ garbas ];
  };

}
