{
  lib,
  buildPythonPackage,
  fetchPypi,
  fasteners,
  jinja2,
  pbr,
  python-jenkins,
  pyyaml,
  six,
  stevedore,
  pytestCheckHook,
  setuptools,
  testtools,
  pytest-mock,
  nixosTests,
}:

buildPythonPackage (finalAttrs: {
  pname = "jenkins-job-builder";
  version = "6.4.4";
  pyproject = true;

  # forge at opendev.org does not provide release tarballs
  src = fetchPypi {
    pname = "jenkins_job_builder";
    inherit (finalAttrs) version;
    hash = "sha256-7PpCDpe3KLRpt+R/Nu+qxdDxLKWVqTiCPK3j+nNaum8=";
  };

  postPatch = ''
    export HOME=$(mktemp -d)
  '';

  build-system = [ setuptools ];

  dependencies = [
    pbr
    python-jenkins
    pyyaml
    six
    stevedore
    fasteners
    jinja2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testtools
    pytest-mock
  ];

  passthru.tests = { inherit (nixosTests) jenkins; };

  meta = {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    mainProgram = "jenkins-jobs";
    homepage = "https://jenkins-job-builder.readthedocs.io/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
})
