{ lib
, buildPythonPackage
, fetchFromGitHub
, commentjson
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "resolvelib";
  # Currently this package is only used by Ansible and breaking changes
  # are frequently introduced, so when upgrading ensure the new version
  # is compatible with Ansible
  # https://github.com/NixOS/nixpkgs/pull/128636
  # https://github.com/ansible/ansible/blob/devel/requirements.txt
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    sha256 = "198vfv78hilpg0d0mjzchzp9zk6239wnra61vlsgwpcgz66d2bgv";
  };

  nativeCheckInputs = [
    commentjson
    pytestCheckHook
  ];
  # TODO: reenable after updating to >= 1.0.0
  # https://github.com/sarugaku/resolvelib/issues/114
  disabledTests = [
    "shared_parent_dependency"
    "deep_complex_conflict"
    "shared_parent_dependency_with_swapping"
    "spapping_and_rewinding"
    "pruned_unresolved_orphan"
    "conflict_common_parent"
    "same-package"
  ];

  pythonImportsCheck = [
    "resolvelib"
  ];

  meta = with lib; {
    description = "Resolve abstract dependencies into concrete ones";
    homepage = "https://github.com/sarugaku/resolvelib";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}
