{ lib, buildPythonPackage, fetchFromGitHub, isPy27, coloredlogs, property-manager, fasteners, pytestCheckHook, mock, virtualenv }:

buildPythonPackage rec {
  pname = "executor";
  version = "23.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-executor";
    rev = version;
    sha256 = "1jfmagw126di0qd82bydwvryqcxc54pqja3rbx3ny3fv1ahi5s7k";
  };

  propagatedBuildInputs = [ coloredlogs property-manager fasteners ];

  checkInputs = [ pytestCheckHook mock virtualenv ];

  # ignore impure tests
  disabledTests = [
    "option"
    "retry"
    "remote"
    "ssh"
    "foreach"
    "local_context"
    "release"  # meant to be ran on ubuntu to succeed
  ];

  meta = with lib; {
    description = "Programmer friendly subprocess wrapper";
    homepage = "https://github.com/xolox/python-executor";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
