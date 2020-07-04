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
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80a7e8d3bebb1e792ff347e9dd072879ce105424224fe804e6671c32a2e8e4bf";
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
