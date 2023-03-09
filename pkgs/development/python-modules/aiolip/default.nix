{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiolip";
  version = "1.1.6";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    sha256 = "1bgmcl8q1p6f2xm3w2qylvla6vf6bd1p2hfwj4l8w6w0w04vr02g";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  pythonImportsCheck = [ "aiolip" ];

  meta = with lib; {
    description = "Python module for the Lutron Integration Protocol";
    homepage = "https://github.com/bdraco/aiolip";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
