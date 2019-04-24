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
    sha256 = "0jp8v0a3yhjv7024y7r4jd4kq008ljra6lxx4143jw3rp72q3afc";
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
