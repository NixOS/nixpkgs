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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sarugaku";
    repo = "resolvelib";
    rev = version;
    sha256 = "sha256-QDHEdVET7HN2ZCKxNUMofabR+rxJy0erWhNQn94D7eI=";
  };

  checkInputs = [
    commentjson
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Resolve abstract dependencies into concrete ones";
    homepage = "https://github.com/sarugaku/resolvelib";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}
