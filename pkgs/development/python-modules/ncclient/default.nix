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
  version = "0.6.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    tag = "v${version}";
    hash = "sha256-l2c+8fMXSx6rMUu+lbyABs1G3llZFD4rI4V1Y729OMs=";
  };

  propagatedBuildInputs = [
    paramiko
    lxml
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ncclient" ];

  meta = with lib; {
    description = "Python library for NETCONF clients";
    homepage = "https://github.com/ncclient/ncclient";
    changelog = "https://github.com/ncclient/ncclient/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ xnaveira ];
  };
}
