{ lib
, fetchPypi
, buildPythonPackage
, isPy27
, ansible
, pyyaml
, setuptools_scm
, ruamel_yaml
, rich
, pytestCheckHook
, pytestcov
, pytest_xdist
, git
}:

buildPythonPackage rec {
  pname = "ansible-lint";
  version = "4.3.6";
  # pip is not able to import version info on raumel.yaml
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fn7mdykm4id78k4faibi92q9yxbjbyxb90ww0by03c31m8z5348";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pyyaml ansible ruamel_yaml rich ];
  checkInputs = [ pytestCheckHook pytestcov pytest_xdist git ];

  postPatch = ''
    patchShebangs bin/ansible-lint
    substituteInPlace setup.cfg \
      --replace "setuptools_scm_git_archive>=1.0" ""
  '';

  # give a hint to setuptools_scm on package version
  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    pytest -k 'not test_run_playbook_github and not test_run_single_role_path_no_trailing_slash_script'
  '';

  meta = with lib; {
    homepage = "https://github.com/ansible/ansible-lint";
    description = "Best practices checker for Ansible";
    license = licenses.mit;
    maintainers = [ maintainers.sengaya ];
  };
}
