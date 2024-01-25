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
  version = "6.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-queP6RBpw32PXbpz6StIE6Pb7RNsm2O4tNarrDwb2cU=";
  };

  postPatch = ''
    # relax version constraint, https://storyboard.openstack.org/#!/story/2009723
    substituteInPlace requirements.txt --replace 'PyYAML>=3.10.0,<6' 'PyYAML>=3.10.0'

    # Allow building with setuptools from nixpkgs.
    # Related: https://github.com/NixOS/nixpkgs/issues/238226.
    substituteInPlace requirements.txt --replace 'setuptools<=65.7.0' 'setuptools'

    export HOME=$TMPDIR
  '';

  propagatedBuildInputs = [ pbr python-jenkins pyyaml six stevedore fasteners jinja2 ];

  # Need to fix test deps, relies on stestr and a few other packages that aren't available on nixpkgs
  checkPhase = "$out/bin/jenkins-jobs --help";

  meta = with lib; {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    homepage = "https://docs.openstack.org/infra/jenkins-job-builder/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };

}
