{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "maxcube-api";
  version = "0.4.3";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hackercowboy";
    repo = "python-${pname}";
    rev = "V${version}";
    sha256 = "10k61gfpnqljf3p3qxr97xq7j67a9cr4ivd9v72hdni0znrbx6ym";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "license=license" "license='MIT'"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "testSendRadioMsgClosesConnectionOnErrorAndRetriesIfReusingConnection"
    "testSendRadioMsgReusesConnection"
  ];

  pythonImportsCheck = [
    "maxcube"
    "maxcube.cube"
  ];

  meta = with lib; {
    description = "eQ-3/ELV MAX! Cube Python API";
    homepage = "https://github.com/hackercowboy/python-maxcube-api";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
