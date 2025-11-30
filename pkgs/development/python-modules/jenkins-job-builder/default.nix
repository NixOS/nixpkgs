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

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "6.4.2";
  format = "setuptools";

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G+DVRd6o3GwTdFNnJkotIidrxexJZSdgCGXTA4KnJJA=";
  };

  postPatch = ''
    export HOME=$(mktemp -d)
  '';

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
}
