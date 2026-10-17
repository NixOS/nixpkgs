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
    hash = "sha256-1Zu+sv0g2gbF2antSDJL6hh5cD8pdzzucJJie90LZoI=";
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
