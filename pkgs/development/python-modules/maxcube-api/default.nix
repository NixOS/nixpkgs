{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "maxcube-api";
  version = "0.4.3";
  format = "setuptools";

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

  meta = {
    description = "eQ-3/ELV MAX! Cube Python API";
    homepage = "https://github.com/hackercowboy/python-maxcube-api";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
