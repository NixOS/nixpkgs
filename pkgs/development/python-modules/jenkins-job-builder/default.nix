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
  fetchpatch,
  testtools,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "jenkins-job-builder";
  version = "6.4.1";

  build-system = [ setuptools ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Re7rNAcm0cpSx1tmSzTjfDlW7y236lzFKFjVw0uUTmw=";
  };

  patches = [
    (fetchpatch {
      url = "https://opendev.org/jjb/jenkins-job-builder/commit/7bf0dacd80d6da7b8562db05f9187140e42947c8.patch";
      hash = "sha256-2z7axGgVV5Z7A11JiQhlrjjXDKYe+X6NrJEuXd986Do=";
    })
  ];

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

  meta = {
    description = "Jenkins Job Builder is a system for configuring Jenkins jobs using simple YAML files stored in Git";
    mainProgram = "jenkins-jobs";
    homepage = "https://jenkins-job-builder.readthedocs.io/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
  };
}
