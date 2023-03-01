{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, xmldiff
}:

buildPythonPackage rec {
  pname = "psrpcore";
  version = "0.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KMSyqXKhNH+i9Y0Mx3DHCwJZOkl4Va2n0zu0TEitslU=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    pytestCheckHook
    xmldiff
  ];

  pythonImportsCheck = [
    "psrpcore"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/jborean93/psrpcore/issues/22
    "test_remote_stream_options"
    "test_ps_flags"
  ];


  meta = with lib; {
    description = "Library for the PowerShell Remoting Protocol (PSRP)";
    homepage = "https://github.com/jborean93/psrpcore";
    changelog = "https://github.com/jborean93/psrpcore/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
