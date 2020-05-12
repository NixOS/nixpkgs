{ lib, buildPythonPackage, fetchPypi, isPy27
, fasteners
, jinja2
, pbr
, python-jenkins
, pyyaml
, six
, stevedore
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0znnw1vnvnm8a6gfrk479s2b9hzlxi4qy57c9a47qphvx3mklm8x";
  };

  postPatch = ''
    export HOME=$TMPDIR
  '';

  propagatedBuildInputs = [ pbr python-jenkins pyyaml six stevedore fasteners jinja2 ];

  # Need to fix test deps, relies on stestr and a few other packages that aren't available on nixpkgs
  checkPhase = ''$out/bin/jenkins-jobs --help'';

  meta = with lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    homepage = "https://docs.openstack.org/infra/jenkins-job-builder/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
