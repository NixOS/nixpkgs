{ lib, buildPythonPackage, fetchPypi, fasteners
, jinja2
, pbr
, python-jenkins
, pyyaml
, six
, stevedore
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "6.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kV2g1qbS5L7bEqfPijj60eK+pbTc8SAs/tctpNv0PFs=";
  };

  postPatch = ''
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = [ pbr python-jenkins pyyaml six stevedore fasteners jinja2 ];

  # Need to fix test deps, relies on stestr and a few other packages that aren't available on nixpkgs
  checkPhase = "$out/bin/jenkins-jobs --help";

  meta = with lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    mainProgram = "jenkins-jobs";
    homepage = "https://jenkins-job-builder.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
