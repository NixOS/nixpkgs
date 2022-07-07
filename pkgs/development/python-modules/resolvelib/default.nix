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

  checkInputs = [
    commentjson
    pytestCheckHook
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
