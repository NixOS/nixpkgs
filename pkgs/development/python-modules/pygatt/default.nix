{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, nose
, pexpect
, pyserial
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pygatt";
  version = "4.0.5";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "peplin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zdfxidiw0l8n498sy0l33n90lz49n25x889cx6jamjr7frlcihd";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  passthru.optional-dependencies.GATTTOOL = [
    pexpect
  ];

  nativeCheckInputs = [
    mock
    nose
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.GATTTOOL;

  postPatch = ''
    # Not support for Python < 3.4
    substituteInPlace setup.py --replace "'enum-compat'" ""
  '';

  pythonImportsCheck = [ "pygatt" ];

  meta = with lib; {
    description = "Python wrapper the BGAPI for accessing Bluetooth LE Devices";
    homepage = "https://github.com/peplin/pygatt";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ fab ];
  };
}
