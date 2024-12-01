{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paramiko,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "ncclient";
  version = "0.6.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-IMCMlGt5/G4PRz525ZomsovU55vBnGhHndBtC7ym6lc=";
  };

  propagatedBuildInputs = [
    paramiko
    lxml
    six
  ] ++ paramiko.optional-dependencies.ed25519;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ncclient" ];

  meta = with lib; {
    description = "Python library for NETCONF clients";
    homepage = "https://github.com/ncclient/ncclient";
    changelog = "https://github.com/ncclient/ncclient/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
