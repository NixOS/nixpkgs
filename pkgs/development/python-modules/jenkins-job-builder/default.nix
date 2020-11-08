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
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20efe98718e61ea7bd69b2178d93c5435bbf2e1ba78a47366632c84970e026c9";
  };

  postPatch = ''
    export HOME=$TMPDIR
  '';

  requiredPythonModules = [ pbr python-jenkins pyyaml six stevedore fasteners jinja2 ];

  # Need to fix test deps, relies on stestr and a few other packages that aren't available on nixpkgs
  checkPhase = ''$out/bin/jenkins-jobs --help'';

  meta = with lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    homepage = "https://docs.openstack.org/infra/jenkins-job-builder/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
