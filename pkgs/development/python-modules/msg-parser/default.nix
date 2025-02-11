{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # dependencies
  olefile,
  # test dependencies
  pytestCheckHook,
}:
let
  pname = "msg-parser";
  version = "1.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vikramarsid";
    repo = "msg_parser";
    rev = "4100b553b24895b489ebd414c771933fc1e558d3";
    hash = "sha256-srDk6w8nzt0dyGCFQWfVCnKb4LawHoqoHX6d1l1dAmM=";
  };

  propagatedBuildInputs = [ olefile ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python module to read, parse and converting Microsoft Outlook MSG E-Mail files";
    mainProgram = "msg_parser";
    homepage = "https://github.com/vikramarsid/msg_parser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ happysalada ];
  };
}
