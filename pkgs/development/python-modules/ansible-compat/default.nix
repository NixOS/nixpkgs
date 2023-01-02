{ lib
, buildPythonPackage
, fetchPypi
, ansible-core
, flaky
, pytest-mock
, pytestCheckHook
, pyyaml
, setuptools-scm
, subprocess-tee
}:

buildPythonPackage rec {
  pname = "ansible-compat";
  version = "2.2.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CN7dzQodxrqr5nSwfG/4ghGEksEj0oH1bwGQUnGn/8Q=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
    subprocess-tee
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$PATH:$out/bin
  '';

  checkInputs = [
    ansible-core
    flaky
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # require network
    "test_prepare_environment_with_collections"
    "test_prerun_reqs_v1"
    "test_prerun_reqs_v2"
    "test_require_collection_wrong_version"
    "test_require_collection"
    "test_install_collection"
    "test_install_collection_dest"
    "test_upgrade_collection"
    "test_require_collection_no_cache_dir"
    "test_runtime"
  ];

  pythonImportsCheck = [ "ansible_compat" ];

  meta = with lib; {
    description = "A python package containing functions that help interacting with various versions of Ansible";
    homepage = "https://github.com/ansible/ansible-compat";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
