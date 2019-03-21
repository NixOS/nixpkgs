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
  version = "2.9.1";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fba5f3efe8bd06d559f06a5d3bd68da5a7395541fcd370053a8174d08519e3d0";
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
